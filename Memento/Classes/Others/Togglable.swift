//
//  Togglable.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - Togglable

protocol Togglable {
    
    // MARK: Methods
    
    mutating func toggle()
    
}

// MARK: - OnOffSwitch

enum OnOffSwitch: Togglable {
    
    // MARK: Values
    
    case off, on
    
    // MARK: Properties
    
    var bool: Bool { return self == .on }
    
    // MARK: Methods
    
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
    
}
