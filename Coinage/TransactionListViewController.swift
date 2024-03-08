//
//  TransactionListViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import UIKit
import CoreData

final class TransactionListViewController: UIViewController{

    private var transactions = [Transaction]()
    private let transactionListTableView = UITableView()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        transactions = fetchTransactions()
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
        transactionListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "transactionCell")
        
        transactionListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            transactionListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func fetchTransactions() -> [Transaction]{
        do{
            transactions = try context.fetch(Transaction.fetchRequest())
        } catch {
            print("Could not fetch transactions")
        }
        return transactions
    }
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: 100, height: 40))
        label.textColor = .red
        label.text = String(transactions[indexPath.row].amount)
        cell.addSubview(label)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(transactions[indexPath.row].date ?? "No date available")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TransactionListViewController: NewTransactionViewDelegate {
    func didAddTransaction() {
        fetchTransactions()
        transactionListTableView.reloadData()
    }
}
