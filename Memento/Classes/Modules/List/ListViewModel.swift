//
//  ListViewModel.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation
import CoreData

// MARK: - FormattedCheckpoint

struct CheckpointWrapper {
    
    // MARK: Properties
    
    var number: String
    var latLngString: String
    var date: String
    var accuracy: String
    var uploaded: Bool
    var highlight: Bool
    var forced: Bool
    
}

// MARK: - Protocols

protocol ListViewModelDelegate: class {
    
    // MARK: Methods
    
    func setupView(viewModel: ListViewModel)
    
}

protocol ListViewModelCoordinatorDelegate: class { }

protocol ListViewModel: ViewModel {
    
    // MARK: Delegates
    
    weak var viewDelegate: ListViewModelDelegate? { get set }
    weak var coordinatorDelegate: ListViewModelCoordinatorDelegate? { get set }
    
    // MARK: Methods
    
    func numberOfItems() -> Int
    func checkpointWrapper(at index: Int) -> CheckpointWrapper?
    
}

// MARK: - Implementation

class ListViewModelImplementation: ListViewModel {
    
    // MARK: Delegates
    
    weak var viewDelegate: ListViewModelDelegate? {
        didSet {
            guard viewDelegate != nil else {
                return
            }
            setupView()
        }
    }
    weak var coordinatorDelegate: ListViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    weak var viewTransmitter: ViewTransmitter!
    private var items: [MOCheckpoint]
    private var latLngFormatter: NumberFormatter
    private var dateFormatter: DateFormatter
    
    // MARK: Initializers
    
    required init(viewTransmitter: ViewTransmitter) {
        self.viewTransmitter = viewTransmitter
        items = MOCheckpoint.checkpoints(context: CoreDataContainer.modelManager.mainManagedObjectContext) ?? []
        latLngFormatter = NumberFormatter()
        latLngFormatter.numberStyle = .decimal
        latLngFormatter.maximumFractionDigits = 6
        latLngFormatter.decimalSeparator = "."
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: CoreDataContainer.modelManager.mainManagedObjectContext)
    }
    
    // MARK: Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Notifications
    
    @objc func managedObjectContextDidSave() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.items = MOCheckpoint.checkpoints(context: CoreDataContainer.modelManager.mainManagedObjectContext) ?? []
            strongSelf.viewDelegate?.setupView(viewModel: strongSelf)
        }
    }
    
    // MARK: Methods
    
    func setupView() {
        viewDelegate?.setupView(viewModel: self)
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func checkpointWrapper(at index: Int) -> CheckpointWrapper? {
        guard let item = items[safe: index] else { return nil }
        let number = "#\(numberOfItems() - index)"
        let latLng = "\(latLngFormatter.string(from: NSNumber(floatLiteral: item.latitude)).or("--")), \(latLngFormatter.string(from: NSNumber(floatLiteral: item.longitude)).or("--"))"
        let date = "\(dateFormatter.string(from: item.addedAt.or(NSDate(timeIntervalSince1970: 0)) as Date))"
        let accuracy = "\(DesiredAccuracyOptions(accuracy: item.desiredAccuracy).string)"
        let uploaded = item.uploaded
        let highlight = NSCalendar.current.isDateInToday(item.addedAt.or(NSDate(timeIntervalSince1970: 0)) as Date)
        let forced = DesiredAccuracyOptions(accuracy: item.desiredAccuracy) == .count
        return CheckpointWrapper(number: number, latLngString: latLng, date: date, accuracy: accuracy, uploaded: uploaded, highlight: highlight, forced: forced)
    }
    
}
