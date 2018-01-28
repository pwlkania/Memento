//
//  UIView+Extensions.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit

// MARK: - UIView

extension UIView {
    
    // MARK: Methods
    
    func fulfillSuperview(topConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leadingConstant: CGFloat = 0, trailingConstant: CGFloat = 0) {
        assert(superview != nil, "View should have a superview")
        
        guard let superview = superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: self,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: superview,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: topConstant)
        let bottomConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: superview,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: bottomConstant)
        let leadingConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: superview,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: leadingConstant)
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: superview,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: trailingConstant)
        
        superview.addConstraints([bottomConstraint, topConstraint, leadingConstraint, trailingConstraint])
    }
    
}
