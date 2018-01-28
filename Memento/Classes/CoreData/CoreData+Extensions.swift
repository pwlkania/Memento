//
//  CoreData+Extensions.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import CoreData

// MARK: - NSManagedObjectContext extensions

extension NSManagedObjectContext {
    
    func cascadeSyncSave() {
        performAndWait {
            do {
                try self.save()
            } catch {
                let saveError = error as NSError
                debugPrint("Unable to Save Changes")
                debugPrint("\(saveError), \(saveError.localizedDescription)")
            }
        }
        if let parent = parent {
            parent.cascadeSyncSave()
        }
    }
    
    func createRecord(for entity: String) -> NSManagedObject? {
        var result: NSManagedObject? = nil
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: self)
        if let entityDescription = entityDescription {
            result = NSManagedObject(entity: entityDescription, insertInto: self)
        }
        return result
    }
    
    func fetchRecordsForEntity(entity: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        var result = [NSManagedObject]()
        do {
            let records = try fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            debugPrint("Unable to fetch managed objects for entity \(entity).")
        }
        return result
    }
    
}

// MARK: - Nameable

protocol Nameable {
    
    var entityName: String { get }
    static var entityName: String { get }
    
}

// MARK: - NSManagedObject extensions

extension NSManagedObject: Nameable {
    
    var stringId: String {
        return objectID.uriRepresentation().absoluteString
    }
    
    var entityName: String {
        return String(describing: type(of: self))
    }
    
    static var entityName: String {
        return String(describing: self)
    }
    
}
