//
//  MainCoordinator.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MainCoordinator

protocol MainCoordinator: Coordinator {
    
    // MARK: Properties
    
    var window: UIWindow { get set }
    
    // MARK: Initializers
    
    init(window: UIWindow)
    
}
