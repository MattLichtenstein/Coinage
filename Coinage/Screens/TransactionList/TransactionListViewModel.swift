//
//  TransactionListViewModel.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 4/13/24.
//

import Foundation
import UIKit
import CoreData

final class TransactionListViewModel {
    private(set) var transactions = [Transaction]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var updateView: (() -> ())?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onTransactionAdded), name: .transactionListChanged, object: nil)
        fetchTransactions()
    }
    
    func fetchTransactions() {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            transactions = try context.fetch(fetchRequest)
            updateView?()
        } catch {
            print("Could not fetch transactions")
        }
    }
    
    func getFormattedTimestamp(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let formatter = DateFormatter()

        let daysDifference = calendar.dateComponents([.day], from: date, to: now).day ?? 0
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mma"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if daysDifference <= 6 && daysDifference >= 0 {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        else {
            formatter.dateFormat = "M/d/yy"
            return formatter.string(from: date)
        }
    }
    
    @objc
    func onTransactionAdded() {
        fetchTransactions()
    }
}

//extension TransactionListViewModel: NewTransactionViewDelegate {
//    func didAddTransaction() {
//        fetchTransactions()
//        transactionListTableView.reloadData()
//    }
//}
//
//extension TransactionListViewModel: SettingsViewControllerDelegate {
//    func didDeleteAllTransactions() {
//        fetchTransactions()
//        transactionListTableView.reloadData()
//    }

