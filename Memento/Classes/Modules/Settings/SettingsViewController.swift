//
//  SettingsViewController.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit
import CoreLocation
import HexColors
import Shared

// MARK: - SettingsTableCell

class SettingsTableCell: UITableViewCell { }

// MARK: - SettingsViewController

class SettingsViewController: UIViewController, StoryboardLoader, ViewTransmitter {
    
    // MARK: StoryboardLoader
    
    static var storyboardId = "SettingsViewController"
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var viewModel: SettingsViewModel?
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDelegate = self
    }
    
    // MARK: Actions
    
    @IBAction func closeButtonTouched(_ sender: UIBarButtonItem) {
        viewModel?.doneButtonTouched()
    }
    
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(for: section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableCell
        if let item = viewModel?.item(for: indexPath) {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.selected ? .checkmark : .none
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor("ffffff", alpha: 0.5)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel?.header(for: section)
        headerView.addSubview(label)
        label.fulfillSuperview(leadingConstant: 15)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.update(for: indexPath)
    }
    
}

// MARK: - MainViewModelDelegate

extension SettingsViewController: SettingsViewModelDelegate {
    
    func setupView(viewModel: SettingsViewModel) {
        tableView.reloadData()
    }
    
}
