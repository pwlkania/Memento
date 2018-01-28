//
//  TodayViewController.swift
//  Widget
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftWormhole
import Shared

// MARK: - WidgetCell

class WidgetCell: UITableViewCell {
    
    // MARK Outlets
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
}

// MARK: - TodayViewController

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    let wormhole = SwiftWormhole(appGroupIdentifier: "group.com.widenue")
    var connectedToHost = false
    var trackLocationEnabled = false
    var forceUpdateEnabled = false
    var sendToCloudEnabled = false
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wormhole?.listen(identifier: WormholeMessage.widgetIdentifier) { [weak self] (message) in
            if let message = message as? WormholeMessage {
                switch message.option {
                case .trackLocation:
                    self?.trackLocationEnabled = message.enabled
                case .forceUpdate:
                    self?.forceUpdateEnabled = message.enabled
                case .sendToCloud:
                    self?.sendToCloudEnabled = message.enabled
                case .ping:
                    break
                }
                self?.connectedToHost = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.tableView.reloadData()
                }
            }
        }
        
        // At launch, ask host app about current status
        wormhole?.post(identifier: WormholeMessage.hostIdentifier, message: WormholeMessage(option: .ping, enabled: false))
    }
    
    // MARK: Methods
    
    @objc func switchAction(sender: UISwitch) {
        if sender.tag == 0 {
            wormhole?.post(identifier: WormholeMessage.hostIdentifier, message: WormholeMessage(option: .trackLocation, enabled: sender.isOn))
        } else if sender.tag == 1 {
            wormhole?.post(identifier: WormholeMessage.hostIdentifier, message: WormholeMessage(option: .forceUpdate, enabled: sender.isOn))
        } else {
            wormhole?.post(identifier: WormholeMessage.hostIdentifier, message: WormholeMessage(option: .sendToCloud, enabled: sender.isOn))
        }
    }
    
}

// MARK: - UITableViewDataSource

extension TodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WidgetCell
        
        switch indexPath.row {
        case WormholeOption.trackLocation.rawValue:
            cell.iconImageView.image = UIImage(named: "location")
            cell.infoLabel.text = "Track my location"
            cell.onOffSwitch.isOn = trackLocationEnabled
        case WormholeOption.forceUpdate.rawValue:
            cell.iconImageView.image = UIImage(named: "timer")
            cell.infoLabel.text = "Force update"
            cell.onOffSwitch.isOn = forceUpdateEnabled
        case WormholeOption.sendToCloud.rawValue:
            cell.iconImageView.image = UIImage(named: "cloud")
            cell.infoLabel.text = "Send to the cloud"
            cell.onOffSwitch.isOn = sendToCloudEnabled
        default:
            break
        }
        
        cell.onOffSwitch.tag = indexPath.row
        cell.onOffSwitch.removeTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        cell.onOffSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        
        if !connectedToHost {
            cell.contentView.alpha = 0.5
            cell.onOffSwitch.isEnabled = false
        } else {
            cell.contentView.alpha = 1
            cell.onOffSwitch.isEnabled = true
        }
        
        return cell
    }
    
}
