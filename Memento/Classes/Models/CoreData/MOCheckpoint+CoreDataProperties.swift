//
//  MOCheckpoint+CoreDataProperties.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//
//

import Foundation
import CoreData


extension MOCheckpoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOCheckpoint> {
        return NSFetchRequest<MOCheckpoint>(entityName: "MOCheckpoint")
    }

    @NSManaged public var addedAt: NSDate?
    @NSManaged public var altitude: Double
    @NSManaged public var course: Double
    @NSManaged public var desiredAccuracy: Double
    @NSManaged public var distanceFilter: Double
    @NSManaged public var floor: Double
    @NSManaged public var horizontalAccuracy: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var speed: Double
    @NSManaged public var type: Int16
    @NSManaged public var verticalAccuracy: Double
    @NSManaged public var uploaded: Bool

}
