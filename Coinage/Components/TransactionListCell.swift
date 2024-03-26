//
//  TransactionListCell.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/9/24.
//

import UIKit

class TransactionListCell: UITableViewCell {
    
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 100, left: 10, bottom: 10, right: 10))

    }
    
    func setTransaction(_ transaction: Transaction) {
        amountLabel.text = String(transaction.amount)
        categoryLabel.text = transaction.category?.name
    }
    
    private func setupCell() {
        let iconCircle = UIView()
        let vStack = UIStackView()
        let descriptionLabel = UILabel()

        contentView.addSubview(iconCircle)
        contentView.addSubview(vStack)
        contentView.addSubview(amountLabel)

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

        descriptionLabel.text = "Description"
        categoryLabel.text = "Category"
        
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
    }
}
