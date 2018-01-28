//
//  ViewTransmitter.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit

// MARK: - ViewTransmitter

protocol ViewTransmitter: class {
    
    // MARK: Properties
    
    var transmitter: UIViewController { get }
    
}

// MARK: - Extensions

extension ViewTransmitter where Self: UIViewController {
    
    // MARK: Properties
    
    var transmitter: UIViewController {
        return self
    }
    
}
