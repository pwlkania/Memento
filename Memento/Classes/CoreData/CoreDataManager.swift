//
//  CoreDataManager.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreDataManager

final class CoreDataManager {
    
    // MARK: - Properties
    let modelName: String
    let bundle: Bundle
    let persistentStoreUrl: URL?
    
    // MARK: -
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = self.bundle.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // URL Application Support Directory
        let applicationSupportDirectoryUrl = self.persistentStoreUrl ?? fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = self.persistentStoreUrl != nil ? applicationSupportDirectoryUrl : applicationSupportDirectoryUrl.appendingPathComponent(storeName)
        
        do {
            // Add Persistent Store
            let options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
            
            // Disable iCloud backup (Apple might reject app)
            if let persistentStore = persistentStoreCoordinator.persistentStore(for: persistentStoreURL) {
            }
        } catch let error {
            fatalError("Unable to Add Persistent Store: \(error)")
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: - Initialization
    init(modelName: String, bundle: Bundle, persistentStoreUrl: URL? = nil) {
        self.modelName = modelName
        self.bundle = bundle
        self.persistentStoreUrl = persistentStoreUrl
    }
    
    // MARK: - Notification Handling
    func saveChanges(_ notification: Notification) {
        saveChanges()
    }
    
    // MARK: - Helper Methods
    
    private func saveChanges() {
        mainManagedObjectContext.performAndWait({
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
            
            self.privateManagedObjectContext.perform({
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    print("\(saveError), \(saveError.localizedDescription)")
                }
            })
        })
    }
    
}
