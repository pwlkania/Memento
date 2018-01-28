//
//  SettingsViewModel.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - DesiredAccuracyOptions

enum DesiredAccuracyOptions: Int {
    
    // MARK: Values
    
    case best, tenMeters, hundredMeters, kilometer, threeKilometers, count
    
    // MARK: Properties
    
    var string: String {
        switch self {
        case .best:
            return "Best"
        case .tenMeters:
            return "10 meters"
        case .hundredMeters:
            return "100 meters"
        case .kilometer:
            return "1 kilometer"
        case .threeKilometers:
            return "3 kilometers"
        case .count:
            return "Forced"
        }
    }
    
    var locationAccuracy: CLLocationAccuracy {
        switch self {
        case .best:
            return kCLLocationAccuracyBest
        case .tenMeters:
            return kCLLocationAccuracyNearestTenMeters
        case .hundredMeters:
            return kCLLocationAccuracyHundredMeters
        case .kilometer:
            return kCLLocationAccuracyKilometer
        case .threeKilometers:
            return kCLLocationAccuracyThreeKilometers
        case .count:
            return kCLLocationAccuracyBestForNavigation
        }
    }
    
    init(accuracy: CLLocationAccuracy) {
        switch accuracy {
        case kCLLocationAccuracyBest:
            self = .best
        case kCLLocationAccuracyNearestTenMeters:
            self = .tenMeters
        case kCLLocationAccuracyHundredMeters:
            self = .hundredMeters
        case kCLLocationAccuracyKilometer:
            self = .kilometer
        case kCLLocationAccuracyThreeKilometers:
            self = .threeKilometers
        default:
            self = .count
        }
    }
}

enum UpdatePeriodOptions: Int {
    
    // MARK: Values
    
    case off, minute, twoMins, threeMins, fiveMins, tenMins, fifteenMins, thirtyMins, hour, count
    
    // MARK: Properties
    
    var string: String {
        switch self {
        case .minute:
            return "1 minute"
        case .twoMins:
            return "2 minutes"
        case .threeMins:
            return "3 minutes"
        case .fiveMins:
            return "5 minutes"
        case .tenMins:
            return "10 minutes"
        case .fifteenMins:
            return "15 minutes"
        case .thirtyMins:
            return "30 minutes"
        case .hour:
            return "1 hour"
        case .off:
            return "Off"
        case .count:
            return "Off"
        }
    }
    
    var timeInterval: TimeInterval {
        switch self {
        case .count:
            fallthrough
        case .off:
            return 60 * 60 * 24 // just in case
        case .minute:
            return 60
        case .twoMins:
            return 60 * 2
        case .threeMins:
            return 60 * 3
        case .fiveMins:
            return 60 * 5
        case .tenMins:
            return 60 * 10
        case .fifteenMins:
            return 60 * 15
        case .thirtyMins:
            return 60 * 30
        case .hour:
            return 60 * 60
        }
    }
    
}

// MARK: - Protocols

protocol SettingsViewModelDelegate: class {
    
    // MARK: Methods
    
    func setupView(viewModel: SettingsViewModel)
    
}

protocol SettingsViewModelCoordinatorDelegate: class {
    
    // MARK: Methods
    
    func shouldDismissSettingsView(viewModel: SettingsViewModel)
    
}

protocol SettingsViewModel: ViewModel {
    
    // MARK: Delegates
    
    weak var viewDelegate: SettingsViewModelDelegate? { get set }
    weak var coordinatorDelegate: SettingsViewModelCoordinatorDelegate? { get set }
    
    // MARK: Properties
    
    var locationManager: LocationManagerModel? { get set }
    var mainViewModel: MainViewModel? { get set }
    
    // MARK: Methods
    
    func doneButtonTouched()
    func update(for selectedIndex: IndexPath)
    func numberOfSections() -> Int
    func numberOfItems(for section: Int) -> Int
    func item(for indexPath: IndexPath) -> (title: String, selected: Bool)
    func header(for section: Int) -> String
}

// MARK: - Implementation

class SettingsViewModelImplementation: SettingsViewModel {
    
    // MARK: Delegates
    
    weak var viewDelegate: SettingsViewModelDelegate? {
        didSet {
            guard viewDelegate != nil else {
                return
            }
            setupView()
        }
    }
    weak var coordinatorDelegate: SettingsViewModelCoordinatorDelegate?
    var locationManager: LocationManagerModel?
    var mainViewModel: MainViewModel?
    
    // MARK: Properties
    
    weak var viewTransmitter: ViewTransmitter!
    
    // MARK: Initializers
    
    required init(viewTransmitter: ViewTransmitter) {
        self.viewTransmitter = viewTransmitter
    }
    
    // MARK: Methods
    
    func setupView() {
        viewDelegate?.setupView(viewModel: self)
    }
    
    func doneButtonTouched() {
        coordinatorDelegate?.shouldDismissSettingsView(viewModel: self)
    }
    
    func update(for selectedIndex: IndexPath) {
        if selectedIndex.section == 0, let desiredAccuracy = DesiredAccuracyOptions(rawValue: selectedIndex.row) {
            locationManager?.desiredAccuracy = desiredAccuracy.locationAccuracy
            locationManager?.distanceFilter = desiredAccuracy.locationAccuracy
        } else if let updatePeriodOptions = UpdatePeriodOptions(rawValue: selectedIndex.row) {
            mainViewModel?.updatePeriod = updatePeriodOptions
        }
        viewDelegate?.setupView(viewModel: self)
        mainViewModel?.setupView()
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfItems(for section: Int) -> Int {
        if section == 0 {
            return DesiredAccuracyOptions.count.rawValue
        } else {
            return UpdatePeriodOptions.count.rawValue
        }
    }
    
    func item(for indexPath: IndexPath) -> (title: String, selected: Bool) {
        if indexPath.section == 0, let desiredAccuracyOptions = DesiredAccuracyOptions(rawValue: indexPath.row) {
            return (desiredAccuracyOptions.string, desiredAccuracyOptions.locationAccuracy == locationManager?.desiredAccuracy)
        } else if let updatePeriodOptions = UpdatePeriodOptions(rawValue: indexPath.row) {
            return (updatePeriodOptions.string, updatePeriodOptions.timeInterval == mainViewModel?.updatePeriod.timeInterval)
        }
        return ("", false)
    }
    
    func header(for section: Int) -> String {
        if section == 0 {
            return "Desired accuracy"
        } else {
            return "Force update every"
        }
    }
    
}
