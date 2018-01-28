//
//  MainViewModel.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import NotificationBannerSwift
import SwiftyUserDefaults
import CoreLocation
import FirebaseDatabase
import SwiftWormhole
import Shared

// MARK: - Protocols

protocol MainViewModelDelegate: class {
    
    // MARK: Methods
    
    func setupView(viewModel: MainViewModel)
    
}

protocol MainViewModelCoordinatorDelegate: class {
    
    // MARK: Methods
    
    @discardableResult func shouldShowSettingsView(viewModel: MainViewModel, locationManager: LocationManagerModel) -> ViewTransmitter?
    @discardableResult func shouldShowListView(viewModel: MainViewModel) -> ViewTransmitter?
    
}

protocol MainViewModel: ViewModel {
    
    // MARK: Delegates
    
    weak var viewDelegate: MainViewModelDelegate? { get set }
    weak var coordinatorDelegate: MainViewModelCoordinatorDelegate? { get set }
    
    // MARK: Properties
    
    var trackOnOffSwitch: OnOffSwitch { get }
    var uploadOnOffSwitch: OnOffSwitch { get }
    var locationManager: LocationManagerModel { get }
    var updatePeriod: UpdatePeriodOptions { get set }
    
    // MARK: Methods
    
    func didTapTrackingButton()
    func didSwipeUpTrackButton()
    func didTapUploadButton()
    func didTapSettingsButton()
    func didTapEventsButton()
    func info() -> String
    
}

// MARK: - Implementation

class MainViewModelImplementation: MainViewModel {
    
    // MARK: Properties
    
    var trackOnOffSwitch: OnOffSwitch = .off
    var uploadOnOffSwitch: OnOffSwitch = .off
    var locationManager: LocationManagerModel = LocationManager()
    var updatePeriod: UpdatePeriodOptions {
        set {
            Defaults[.updatePeriod] = newValue.rawValue
            if newValue != .off { prevUpdatePeriod = newValue }
            setupTimer()
        }
        get {
            if let period = UpdatePeriodOptions(rawValue: Defaults[.updatePeriod]) {
                return period
            } else {
                return .off
            }
        }
    }
    private var prevUpdatePeriod: UpdatePeriodOptions {
        set {
            Defaults[.prevUpdatePeriod] = newValue.rawValue
        }
        get {
            if let period = UpdatePeriodOptions(rawValue: Defaults[.prevUpdatePeriod]) {
                return period
            } else {
                return updatePeriod
            }
        }
    }
    private var timer: Timer?
    private let wormhole = SwiftWormhole(appGroupIdentifier: "group.com.widenue")
    
    // MARK: Delegates
    
    weak var viewDelegate: MainViewModelDelegate? {
        didSet {
            guard viewDelegate != nil else {
                return
            }
            setupView()
        }
    }
    weak var coordinatorDelegate: MainViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    weak var viewTransmitter: ViewTransmitter!
    
    // MARK: Initializers
    
    required init(viewTransmitter: ViewTransmitter) {
        self.viewTransmitter = viewTransmitter
        locationManager.delegate = self
        setupTimer()
        setupWormhole()
    }
    
    // MARK: Methods
    
    func setupView() {
        viewDelegate?.setupView(viewModel: self)
    }
    
    func didTapTrackingButton() {
        trackOnOffSwitch.toggle()
        
        if trackOnOffSwitch == .on {
            if CLLocationManager.authorizationStatus() != .authorizedAlways {
                let banner = NotificationBanner(title: "Error", subtitle: "Application doesn't have permission to get your location", style: .danger)
                banner.show()
                trackOnOffSwitch.toggle()
                return
            } else {
                let banner = NotificationBanner(title: "Success", subtitle: "Started tracking your location. Accuracy: \(locationManager.desiredAccuracyString)", style: .success)
                banner.show()
                locationManager.startUpdating()
            }
        } else {
            let banner = NotificationBanner(title: "Warning", subtitle: "Stopped tracking your location", style: .warning)
            banner.show()
            locationManager.stopUpdating()
        }
        
        setupView()
        setupTimer()
    }
    
    func didSwipeUpTrackButton() {
        locationManager.spike()
    }
    
    func didTapUploadButton() {
        uploadOnOffSwitch.toggle()
        
        if uploadOnOffSwitch == .on {
            let banner = NotificationBanner(title: "Success", subtitle: "Enabled cloud synchronization", style: .success)
            banner.show()
        } else {
            let banner = NotificationBanner(title: "Warning", subtitle: "Disabled cloud synchronization", style: .warning)
            banner.show()
        }
        
        setupView()
        upload()
    }
    
    func didTapSettingsButton() {
        _ = coordinatorDelegate?.shouldShowSettingsView(viewModel: self, locationManager: locationManager)
    }
    
    func didTapEventsButton() {
        _ = coordinatorDelegate?.shouldShowListView(viewModel: self)
    }
    
    func info() -> String {
        return "\(locationManager.desiredAccuracyString), \(updatePeriod.string)"
    }
    
    private func upload() {
        if uploadOnOffSwitch == .on {
            let context = CoreDataContainer.modelManager.mainManagedObjectContext
            if let checkpoints = MOCheckpoint.notuUploadedCheckpoints(context: context) {
                for checkpoint in checkpoints {
                    let item: [String : Any] = ["addedAt": checkpoint.addedAt.or(NSDate(timeIntervalSince1970: 0)).timeIntervalSince1970,
                                                "altitude": checkpoint.altitude,
                                                "course": checkpoint.course,
                                                "desiredAccuracy": checkpoint.desiredAccuracy,
                                                "distanceFilter": checkpoint.distanceFilter,
                                                "floor": checkpoint.floor,
                                                "horizontalAccuracy": checkpoint.horizontalAccuracy,
                                                "latitude": checkpoint.latitude,
                                                "longitude": checkpoint.longitude,
                                                "speed": checkpoint.speed,
                                                "type": checkpoint.type,
                                                "verticalAccuracy": checkpoint.verticalAccuracy
                    ]
                    let reference = Database.database().reference()
                    reference.child("locations").childByAutoId().setValue(item)
                    checkpoint.uploaded = true
                }
                context.cascadeSyncSave()
            }
        }
    }
    
    private func setupTimer() {
        timer?.invalidate()
        timer = nil
        guard updatePeriod != .off, trackOnOffSwitch != .off else { return }
        timer = Timer(fireAt: Date(timeInterval: updatePeriod.timeInterval, since: Date()), interval: 0, target: self, selector: #selector(forceSpike), userInfo: nil, repeats: false)
        if let timer = timer {
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    @objc private func forceSpike() {
        locationManager.spike()
        setupTimer()
    }
    
    private func setupWormhole() {
        wormhole?.listen(identifier: WormholeMessage.hostIdentifier) { [weak self] (message) in
            if let message = message as? WormholeMessage {
                switch message.option {
                case .trackLocation where self?.trackOnOffSwitch.bool != message.enabled :
                    self?.didTapTrackingButton()
                case .forceUpdate where message.enabled:
                    if let prevUpdatePeriod = self?.prevUpdatePeriod {
                        self?.updatePeriod = prevUpdatePeriod
                    }
                case .forceUpdate where !message.enabled:
                    self?.updatePeriod = .off
                case .sendToCloud where self?.uploadOnOffSwitch.bool != message.enabled:
                    self?.didTapUploadButton()
                    break
                default:
                    break
                }
            }
            self?.pingWidget()
            self?.setupView()
        }
    }
    
    private func pingWidget() {
        wormhole?.post(identifier: WormholeMessage.widgetIdentifier, message: WormholeMessage(option: .trackLocation, enabled: trackOnOffSwitch.bool))
        wormhole?.post(identifier: WormholeMessage.widgetIdentifier, message: WormholeMessage(option: .forceUpdate, enabled: updatePeriod != .off))
        wormhole?.post(identifier: WormholeMessage.widgetIdentifier, message: WormholeMessage(option: .sendToCloud, enabled: uploadOnOffSwitch.bool))
    }
    
}

// MARK: LocationManagerDelegate

extension MainViewModelImplementation: LocationManagerDelegate {
    
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation?, desiredAccuracy: CLLocationAccuracy, distanceFilter: CLLocationDistance, spike: Bool) {
        guard let location = location else { return }
        
        let context = CoreDataContainer.modelManager.mainManagedObjectContext
        
        if spike {
            let banner = NotificationBanner(title: "Success", subtitle: "Stored your location", style: .success)
            banner.show()
        } else if !spike, let checkpoints = MOCheckpoint.checkpoints(for: Date(), context: context), checkpoints.count > 0 { // note: for some unknown reason, location manager can receive a few locations in a very short amount of time, due to this, we want to limit it to no more than 1 sec
            return
        }
        MOCheckpoint.addCheckpoint(date: Date(), type: spike ? .forced : .subscribe, location: location, distanceFilter: distanceFilter, desiredAccuracy: desiredAccuracy, context: CoreDataContainer.modelManager.mainManagedObjectContext)
        upload()
        debugPrint(location)
    }
    
    func locationManager(_ manager: LocationManager, didFailWithError error: Error) {
        let banner = NotificationBanner(title: "Couldn't determine your location", subtitle: "Error type: \(error)", style: .danger)
        banner.show()
    }
    
    func locationManager(_ manager: LocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didTapTrackingButton() // note: this method will be called at app launch, which is desired
    }
    
    func updateView() {
        viewDelegate?.setupView(viewModel: self)
    }
    
}

// MARK: - SwiftyUserDefaults

extension DefaultsKeys {
    
    static let updatePeriod = DefaultsKey<Int>("updatePeriod")
    static let prevUpdatePeriod = DefaultsKey<Int>("prevUpdatePeriod")
    
}
