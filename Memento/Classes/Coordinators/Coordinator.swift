//
//  Coordinator.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - Coordinator

protocol Coordinator: class {
    
    // MARK: Methods
    
    @discardableResult func start(userInfo: [String: Any]?) -> ViewTransmitter?
    
}
