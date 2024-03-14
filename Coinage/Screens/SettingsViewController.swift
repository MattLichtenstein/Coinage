//
//  SettingsViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/11/24.
//

import CoreData
import UIKit
import SwiftUI

protocol SettingsViewControllerDelegate {
    func didDeleteAllTransactions()
}

final class SettingsViewController: UIViewController {
        
    var delegate: SettingsViewControllerDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Settings"
        
        setupSettingsViewForm()
    }
    
    func setupSettingsViewForm() {
        var settingsView = SettingsView()
        settingsView.delegate = self
        
        let hostingController = UIHostingController(rootView: settingsView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}

extension SettingsViewController: SettingsViewDelegate {    
    func didPressCategories() {
        navigationController?.pushViewController(CategoryListViewController(), animated: true)
    }
    
    func didPressDeleteAllTransactions() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Transaction")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            delegate?.didDeleteAllTransactions()
        } catch {
            print("Could not delete all transactions")
        }
    }
}
