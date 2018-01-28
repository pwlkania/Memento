//
//  SettingsCoordinator.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit

// MARK: - SettingsCoordinator

class SettingsCoordinator: SubCoordinator {
    
    // MARK: Properties
    
    var viewTransmitter: ViewTransmitter
    weak var settingsViewModelCoordinatorDelegate: SettingsViewModelCoordinatorDelegate?
    
    // MARK: Initializers
    
    required init(viewTransmitter: ViewTransmitter) {
        self.viewTransmitter = viewTransmitter
    }
    
    // MARK: Methods
    
    @discardableResult func start(userInfo: [String: Any]?) -> ViewTransmitter? {
        let settingsView = SettingsViewController.loadFromStoryboard()
        let settingsViewModel = SettingsViewModelImplementation(viewTransmitter: settingsView)
        settingsViewModel.coordinatorDelegate = settingsViewModelCoordinatorDelegate
        settingsView.viewModel = settingsViewModel
        settingsView.viewModel?.locationManager = userInfo?["locationManager"] as? LocationManagerModel
        settingsView.viewModel?.mainViewModel = userInfo?["mainViewModel"] as? MainViewModel
        let navigationController = UINavigationController(rootViewController: settingsView)
        viewTransmitter.transmitter.present(navigationController, animated: true, completion: nil)
        return settingsView
    }
    
    func finish(userInfo: [String: Any]?) {
        viewTransmitter.transmitter.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
