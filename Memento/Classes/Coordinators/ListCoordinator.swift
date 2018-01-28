//
//  ListCoordinator.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - ListCoordinator

class ListCoordinator: SubCoordinator {
    
    // MARK: Properties
    
    var viewTransmitter: ViewTransmitter
    weak var listViewModelCoordinatorDelegate: ListViewModelCoordinatorDelegate?
    
    // MARK: Initializers
    
    required init(viewTransmitter: ViewTransmitter) {
        self.viewTransmitter = viewTransmitter
    }
    
    // MARK: Methods
    
    @discardableResult func start(userInfo: [String: Any]?) -> ViewTransmitter? {
        let listView = ListViewController.loadFromStoryboard()
        let listViewModel = ListViewModelImplementation(viewTransmitter: listView)
        listViewModel.coordinatorDelegate = listViewModelCoordinatorDelegate
        listView.viewModel = listViewModel
        viewTransmitter.transmitter.show(listView, sender: nil)
        return listView
    }
    
    func finish(userInfo: [String: Any]?) {
        viewTransmitter.transmitter.navigationController?.popViewController(animated: true)
    }
    
}
