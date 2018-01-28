//
//  CoreDataContainer.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - CoreDataContainer

class CoreDataContainer {
    
    // MARK: Static properties
    
    static let modelManager = CoreDataManager(modelName: "Model", bundle: Bundle(for: CoreDataContainer.self))
    
}
