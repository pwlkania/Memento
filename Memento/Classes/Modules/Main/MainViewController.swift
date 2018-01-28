//
//  MainViewController.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import UIKit

// MARK: - MainViewController

class MainViewController: UIViewController, StoryboardLoader, ViewTransmitter {
    
    // MARK: StoryboardLoader
    
    static var storyboardId = "MainViewController"
    
    // MARK: Views
    
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: Properties
    
    var viewModel: MainViewModel?
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDelegate = self
    }
    
    // MARK: Actions
    
    @IBAction func trackButtonTouched(_ sender: UIButton) {
        viewModel?.didTapTrackingButton()
    }
    
    @IBAction func uploadButtonTouched(_ sender: UIButton) {
        viewModel?.didTapUploadButton()
    }
    
    @IBAction func settingsButtonTouched(_ sender: UIButton) {
        viewModel?.didTapSettingsButton()
    }
    
    @IBAction func eventsButtonTouched(_ sender: UIButton) {
        viewModel?.didTapEventsButton()
    }
    
    @IBAction func trackButtonDidSwipeUp(_ sender: UISwipeGestureRecognizer) {
        viewModel?.didSwipeUpTrackButton()
    }
    
}

// MARK: - MainViewModelDelegate

extension MainViewController: MainViewModelDelegate {
    
    func setupView(viewModel: MainViewModel) {
        trackButton.isSelected = viewModel.trackOnOffSwitch == .on
        uploadButton.isSelected = viewModel.uploadOnOffSwitch == .on
        infoLabel.text = viewModel.info()
    }
    
}
