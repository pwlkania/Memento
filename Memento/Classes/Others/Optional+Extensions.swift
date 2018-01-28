//
//  Optional+Extensions.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - Optional

extension Optional {
    
    // MARK: Methods
    
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
}
