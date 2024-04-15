//
//  TransactionListViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import CoreData
import UIKit

final class TransactionListViewController: UIViewController{

    private let viewModel = TransactionListViewModel()
    private let transactionListTableView = UITableView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Transactions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(transactionListTableView)
        
        setupTableView()
        setupActions()
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
    
    func setupActions() {
        viewModel.updateView = { [weak self] in
            self?.transactionListTableView.reloadData()
        }
    }
    
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionListTableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionListCell
        let transaction = viewModel.transactions[indexPath.row]
        let formattedTimestamp = viewModel.getFormattedTimestamp(date: transaction.timestamp!)
        cell.setTransaction(transaction, formattedTimestamp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
}
