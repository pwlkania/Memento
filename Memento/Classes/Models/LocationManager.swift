//
//  LocationManager.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyUserDefaults

// MARK: - LocationManagerModel

protocol LocationManagerModel {
    
    // MARK: Properties
    
    var delegate: LocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    var desiredAccuracyString: String { get }
    
    // MARK: Methods
    
    func startUpdating()
    func stopUpdating()
    func spike()
    func resetToDefaults()
    
}

// MARK: - LocationManagerDelegate

protocol LocationManagerDelegate {
    
    // MARK: Methods
    
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation?, desiredAccuracy: CLLocationAccuracy, distanceFilter: CLLocationDistance, spike: Bool)
    func locationManager(_ manager: LocationManager, didFailWithError error: Error)
    func locationManager(_ manager: LocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    func updateView()
}

// MARK: - LocationManager

class LocationManager: NSObject, LocationManagerModel {
    
    // MARK: Properties
    
    private var locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy {
        set {
            Defaults[.desiredAccuracy] = newValue
            locationManager.desiredAccuracy = newValue
            delegate?.updateView()
        }
        get {
            if let accuracy = Defaults[.desiredAccuracy] {
                return accuracy
            } else {
                return kCLLocationAccuracyHundredMeters
            }
        }
    }
    var distanceFilter: CLLocationDistance {
        set {
            Defaults[.distanceFilter] = newValue
            locationManager.distanceFilter = newValue
            delegate?.updateView()
        }
        get {
            if let filter = Defaults[.distanceFilter] {
                return filter
            } else {
                return kCLLocationAccuracyHundredMeters
            }
        }
    }
    var desiredAccuracyString: String {
        switch desiredAccuracy {
        case kCLLocationAccuracyBestForNavigation:
            return "best for navigation"
        case kCLLocationAccuracyBest:
            return "best"
        case kCLLocationAccuracyNearestTenMeters:
            return "10 meters"
        case kCLLocationAccuracyHundredMeters:
            return "100 meters"
        case kCLLocationAccuracyKilometer:
            return "1 kilometer"
        case kCLLocationAccuracyThreeKilometers:
            return "3 kilometers"
        default:
            return "unknown"
        }
    }
    
    // MARK: Initializers
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.distanceFilter = distanceFilter
        locationManager.delegate = self
    }
    
    // MARK: Methods
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func spike() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    func resetToDefaults() {
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.distanceFilter = distanceFilter
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager(self, didUpdateLocation: locations.first, desiredAccuracy: manager.desiredAccuracy, distanceFilter: manager.distanceFilter, spike: locationManager.desiredAccuracy == kCLLocationAccuracyBestForNavigation)
        resetToDefaults()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationManager(self, didFailWithError: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManager(self, didChangeAuthorization: status)
    }
    
}

// MARK: - SwiftyUserDefaults

extension DefaultsKeys {
    
    static let desiredAccuracy = DefaultsKey<Double?>("desiredAccuracy")
    static let distanceFilter = DefaultsKey<Double?>("distanceFilter")
    
}
