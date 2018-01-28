//
//  UITableView+Extensions.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit

// MARK: - ReusableView

public protocol ReusableView {
    
    static var reuseableIdentifier: String { get }
    
}

public extension ReusableView {
    
    static var reuseableIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableView { }

// MARK: - NibLoadableView

public protocol NibLoadableView {
    
    static var nibName: String { get }
    
}

public extension NibLoadableView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: NibLoadableView { }

// MARK: - UITableView

public extension UITableView {
    
    public func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: T.reuseableIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseableIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue cell")
        }
        return cell
    }
    
}
