//
//  ViewModel.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - ViewModel

protocol ViewModel: class {
    
    // MARK: Properties
    
    weak var viewTransmitter: ViewTransmitter! { get set }
    
    // MARK: Initializers
    
    init(viewTransmitter: ViewTransmitter)
    
    // MARK: Methods
    
    func setupView()
    
}
