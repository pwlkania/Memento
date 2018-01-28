//
//  AppCoordinator.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit
import HexColors

// MARK: - AppCoordinator

class AppCoordinator: MainCoordinator {
    
    // MARK: Properties
    
    var window: UIWindow
    private(set) var navigationController: UINavigationController!
    
    // MARK: Initializers
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Methods
    
    @discardableResult func start(userInfo: [String: Any]?) -> ViewTransmitter? {
        // Setup main view
        let mainView = MainViewController.loadFromStoryboard()
        let mainViewModel = MainViewModelImplementation(viewTransmitter: mainView)
        mainViewModel.coordinatorDelegate = self
        mainView.viewModel = mainViewModel
        
        // Setup tab bar
        navigationController = UINavigationController(rootViewController: mainView)
        navigationController.navigationBar.tintColor = UIColor("5386E4")
        window.rootViewController = navigationController
        return navigationController
    }
    
}

// MARK: - MainViewModelCoordinatorDelegate

extension AppCoordinator: MainViewModelCoordinatorDelegate {
    
    // MARK: Methods
    
    @discardableResult func shouldShowSettingsView(viewModel: MainViewModel, locationManager: LocationManagerModel) -> ViewTransmitter? {
        let settingsCoordinator = SettingsCoordinator(viewTransmitter: viewModel.viewTransmitter)
        settingsCoordinator.settingsViewModelCoordinatorDelegate = self
        return settingsCoordinator.start(userInfo: ["locationManager": locationManager, "mainViewModel": viewModel])
    }
    
    @discardableResult func shouldShowListView(viewModel: MainViewModel) -> ViewTransmitter? {
        let listCoordinator = ListCoordinator(viewTransmitter: viewModel.viewTransmitter)
        listCoordinator.listViewModelCoordinatorDelegate = self
        return listCoordinator.start(userInfo: nil)
    }
    
}

// MARK: - ListViewModelCoordinatorDelegate

extension AppCoordinator: ListViewModelCoordinatorDelegate { }

// MARK: - SettingsViewModelCoordinatorDelegate

extension AppCoordinator: SettingsViewModelCoordinatorDelegate {
    
    // MARK: Methods
    
    func shouldDismissSettingsView(viewModel: SettingsViewModel) {
        let staticContentCoordinator = SettingsCoordinator(viewTransmitter: viewModel.viewTransmitter)
        staticContentCoordinator.settingsViewModelCoordinatorDelegate = self
        staticContentCoordinator.finish(userInfo: nil)
    }
    
}
