//
//  NewTransactionViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import UIKit

protocol NewTransactionViewDelegate {
    func didAddTransaction()
}

final class NewTransactionViewController: UIViewController {
    
    var newTransactionViewDelegate: NewTransactionViewDelegate?
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 50)
        return valueLabel
    }()
    private let addButton = UIButton()
    private let numPadView = UIStackView()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = []
                
        view.addSubview(valueLabel)
        view.addSubview(numPadView)
        view.addSubview(addButton)
        
        setupValueLabel()
        setupNumpad()
        setupAddButton()
    }
    
    func setupValueLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.bottomAnchor.constraint(equalTo: numPadView.topAnchor, constant: -48),
            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupNumpad() {
        numPadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numPadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            numPadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            numPadView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -32),
            numPadView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        numPadView.axis = .vertical
        numPadView.distribution = .fillEqually
        
        for i in 1...4 {
            let numPadChars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "<"]
            let hStack = UIStackView()
            numPadView.addArrangedSubview(hStack)
            
        
            hStack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hStack.leadingAnchor.constraint(equalTo: numPadView.leadingAnchor),
                hStack.trailingAnchor.constraint(equalTo: numPadView.trailingAnchor),
            ])
            
            hStack.distribution = .fillEqually
            
            for j in 1...3 {
                let button = UIButton()
                hStack.addArrangedSubview(button)
                button.setTitle(numPadChars[(i - 1) * 3 + j - 1], for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 50)
                button.setTitleColor(.label, for: .normal)
                button.addTarget(self, action: #selector(numPadButtonPressed(sender:)), for: .touchUpInside)
//                button.backgroundColor = .secondarySystemBackground
            }
        }
    }
    
    func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        addButton.setTitle("Add transaction", for: .normal)
        addButton.backgroundColor = .secondarySystemBackground
        addButton.setTitleColor(.label, for: .normal)
        addButton.layer.cornerRadius = 12
        addButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
    }
    
    @objc func addTransaction() {
        let transaction = Transaction(context: context)
        transaction.amount = Double(valueLabel.text ?? "0")!
        transaction.date = Date()
        do {
            try context.save()
        } catch {
            print("Could not save transaction")
        }
        
        newTransactionViewDelegate?.didAddTransaction()
    }
    
    @objc func numPadButtonPressed(sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        if let currentText = valueLabel.text, !currentText.isEmpty {
            if buttonText == "<" {
                valueLabel.text!.removeLast()
            }
            else if currentText.count < 8 {
                valueLabel.text! += buttonText
            } else {
                return
            }
        } else {
            valueLabel.text = buttonText
        }
    }
}
