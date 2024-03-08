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
        newTransactionVC.newTransactionViewDelegate = transactionListVC
        
        viewControllers = [newTransactionVC, transactionListNavigationVC]
    }
    
}
