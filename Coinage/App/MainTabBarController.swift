//
//  MainTabViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .secondarySystemBackground
        setupTabs()
    }
    
    func setupTabs() {
        let newTransactionVC = NewTransactionViewController()
        newTransactionVC.tabBarItem.image = UIImage(systemName: "dollarsign")?.withBaselineOffset(fromBottom: 16)

        let transactionListVC = TransactionListViewController()
        let transactionListNavigationVC = UINavigationController(rootViewController: transactionListVC)
        transactionListNavigationVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.portrait")?.withBaselineOffset(fromBottom: 16)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape")?.withBaselineOffset(fromBottom: 16)
        settingsVC.title = "Settings"
        settingsVC.tabBarItem.title = ""
        let settingsNavigationVC = UINavigationController(rootViewController: settingsVC)
        
        viewControllers = [newTransactionVC, transactionListNavigationVC, settingsNavigationVC]
    }
    
}
