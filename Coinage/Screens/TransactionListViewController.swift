//
//  TransactionListViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import CoreData
import UIKit

final class TransactionListViewController: UIViewController{

    private var transactions = [Transaction]()
    private let transactionListTableView = UITableView()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        fetchTransactions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Transactions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(transactionListTableView)
        
        setupTableView()
    }
    
    func setupTableView() {
        transactionListTableView.delegate = self
        transactionListTableView.dataSource = self
        transactionListTableView.register(TransactionListCell.self, forCellReuseIdentifier: "transactionCell")
        transactionListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        transactionListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            transactionListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func fetchTransactions() {
        do{
            transactions = try context.fetch(Transaction.fetchRequest())
        } catch {
            print("Could not fetch transactions")
        }
    }
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionListTableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionListCell
        cell.setTransaction(transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

extension TransactionListViewController: NewTransactionViewDelegate {
    func didAddTransaction() {
        fetchTransactions()
        transactionListTableView.reloadData()
    }
}

extension TransactionListViewController: SettingsViewControllerDelegate {
    func didDeleteAllTransactions() {
        fetchTransactions()
        transactionListTableView.reloadData()
    }
}
