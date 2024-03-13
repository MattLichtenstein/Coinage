//
//  TransactionListCell.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/9/24.
//

import UIKit

class TransactionListCell: UITableViewCell {
    
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTransaction(_ transaction: Transaction) {
        amountLabel.text = String(transaction.amount)
    }
    
    private func setupCell() {
        contentView.addSubview(amountLabel)
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
