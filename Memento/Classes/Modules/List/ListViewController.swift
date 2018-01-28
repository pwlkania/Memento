//
//  ListViewController.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit
import Shared

// MARK: - ListTableCell

class ListTableCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var latLngLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var notuploadedImageView: UIImageView!
}

// MARK: ListViewController

class ListViewController: UIViewController, StoryboardLoader, ViewTransmitter {
    
    // MARK: StoryboardLoader
    
    static var storyboardId = "ListViewController"
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var viewModel: ListViewModel?
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDelegate = self
    }
    
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListTableCell
        if let checkpointWrapper = viewModel?.checkpointWrapper(at: indexPath.row) {
            cell.numberLabel.text = checkpointWrapper.number
            cell.latLngLabel.text = checkpointWrapper.latLngString
            cell.dateLabel.text = checkpointWrapper.date
            cell.accuracyLabel.text = checkpointWrapper.accuracy
            if checkpointWrapper.forced == true {
                cell.accuracyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .black)
            } else {
                cell.accuracyLabel.font = UIFont.systemFont(ofSize: 13)
            }
            cell.notuploadedImageView.isHidden = checkpointWrapper.uploaded
            cell.contentView.alpha = checkpointWrapper.highlight ? 1 : 0.5
        }
        return cell
    }
    
}

// MARK: - MainViewModelDelegate

extension ListViewController: ListViewModelDelegate {
    
    func setupView(viewModel: ListViewModel) {
        tableView.reloadData()
    }
    
}
