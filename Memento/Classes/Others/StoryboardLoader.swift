//
//  StoryboardLoader.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit

// MARK: - StoryboardLoader

protocol StoryboardLoader: class {
    
    // MARK: Static properties
    
    static var storyboardId: String { get }
    static var storyboardControllerId: String { get }
    
}

// MARK: - UIViewController

extension StoryboardLoader where Self: UIViewController {
    
    // MARK: Static properties
    
    static var storyboardControllerId: String {
        return String(describing: self)
    }
    
    // MARK: Static methods
    
    static func loadFromStoryboard() -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: Self.storyboardId, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: Self.storyboardControllerId) as! Self
    }
    
}
