//
//  TransactionListCell.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/9/24.
//

import UIKit

class TransactionListCell: UITableViewCell {
    
    private let descriptionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()
    private let timestampLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTransaction(_ transaction: Transaction, _ timestamp: String) {
        descriptionLabel.text = transaction.name
        categoryLabel.text = transaction.category?.name
        amountLabel.text = String(transaction.amount)
        timestampLabel.text = timestamp
        
        switch CategoryType(rawValue: transaction.category?.type ?? CategoryType.investment.rawValue) {
        case .expense:
            amountLabel.textColor = .systemRed
        case .income:
            amountLabel.textColor = .systemGreen
        case .investment:
            fallthrough
        case .none:
            amountLabel.textColor = .systemGray
        }
    }
    
    private func setupCell() {
        let iconCircle = UIView()
        let vStack = UIStackView()

        contentView.addSubview(iconCircle)
        contentView.addSubview(vStack)
        contentView.addSubview(amountLabel)
        contentView.addSubview(timestampLabel)

        iconCircle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconCircle.widthAnchor.constraint(equalToConstant: 44),
            iconCircle.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        layoutIfNeeded()
        iconCircle.layer.cornerRadius = iconCircle.frame.width / 2
        iconCircle.backgroundColor = .systemGray
        
        vStack.axis = .vertical
        vStack.addArrangedSubview(descriptionLabel)
        vStack.addArrangedSubview(categoryLabel)

        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: iconCircle.trailingAnchor, constant: 12),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
            
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .gray
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timestampLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
}
