//
//  MOCheckpoint+Extensions.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

// MARK: - MOCheckpoint extensions

extension MOCheckpoint {
    
    // MARK: Enums
    
    enum AddType: Int {
        case forced, subscribe
    }
    
    // MARK: Static methods
    
    static func addCheckpoint(date: Date, type: AddType, location: CLLocation, distanceFilter: CLLocationDistance, desiredAccuracy: CLLocationAccuracy, context: NSManagedObjectContext) {
        if let checkpoint = context.createRecord(for: MOCheckpoint.entityName) as? MOCheckpoint {
            checkpoint.addedAt = date as NSDate
            checkpoint.type = Int16(type.rawValue)
            checkpoint.desiredAccuracy = desiredAccuracy
            checkpoint.distanceFilter = distanceFilter
            checkpoint.latitude = location.coordinate.latitude
            checkpoint.longitude = location.coordinate.longitude
            checkpoint.altitude = location.altitude
            checkpoint.floor = Double(location.floor?.level ?? -1)
            checkpoint.course = location.course
            checkpoint.horizontalAccuracy = location.horizontalAccuracy
            checkpoint.verticalAccuracy = location.verticalAccuracy
            checkpoint.speed = location.speed
            context.cascadeSyncSave()
        }
    }
    
    static func checkpoints(for date: Date, context: NSManagedObjectContext) -> [MOCheckpoint]? {
        let predicate = NSPredicate(format: "addedAt >= %@", NSDate(timeInterval: -1, since: date))
        return context.fetchRecordsForEntity(entity: MOCheckpoint.entityName, predicate: predicate) as? [MOCheckpoint]
    }
    
    static func checkpoints(context: NSManagedObjectContext) -> [MOCheckpoint]? {
        let sortDescriptor = NSSortDescriptor(key: "addedAt", ascending: false)
        return context.fetchRecordsForEntity(entity: MOCheckpoint.entityName, sortDescriptors: [sortDescriptor]) as? [MOCheckpoint]
    }
    
    static func notuUploadedCheckpoints(context: NSManagedObjectContext) -> [MOCheckpoint]? {
        let predicate = NSPredicate(format: "uploaded == no")
        let sortDescriptor = NSSortDescriptor(key: "addedAt", ascending: true)
        return context.fetchRecordsForEntity(entity: MOCheckpoint.entityName, predicate: predicate, sortDescriptors: [sortDescriptor]) as? [MOCheckpoint]
    }
    
}
