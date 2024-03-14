//
//  NewTransactionViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import CoreData
import UIKit

protocol NewTransactionViewDelegate {
    func didAddTransaction()
}

final class NewTransactionViewController: UIViewController {
    
    
    var newTransactionViewDelegate: NewTransactionViewDelegate?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let amountLabel: UILabel = {
        let font = UIFont(name: Constants.cmMediumRounded, size:  50)

        let amountLabel = UILabel()
        amountLabel.font = UIFontMetrics.default.scaledFont(for: font!)
        amountLabel.adjustsFontForContentSizeCategory = true

        return amountLabel
    }()
    private lazy var addTransactionButton: UIButton = {
        let addTransactionButton = UIButton()
        addTransactionButton.setTitle("Add", for: .normal)
        addTransactionButton.backgroundColor = .secondarySystemBackground
        addTransactionButton.setTitleColor(.label, for: .normal)
        addTransactionButton.layer.cornerRadius = 10
        addTransactionButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: Constants.cmMediumRounded, size:  18)!)
        addTransactionButton.titleLabel?.adjustsFontForContentSizeCategory = true
        addTransactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        return addTransactionButton
    }()
    private let numPadView: UIStackView = {
        let numPadView = UIStackView()
        numPadView.axis = .vertical
        numPadView.distribution = .fillEqually
        numPadView.spacing = 12
        return numPadView
    }()
    var categoryPicker = PickerButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = []

        view.addSubview(amountLabel)
        view.addSubview(addTransactionButton)
        view.addSubview(numPadView)

        setupValueLabel()
        setupCategoryPicker()
        setupAddTransactionButton()
        setupNumpad()
    }
    
    func setupValueLabel() {
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.bottomAnchor.constraint(equalTo: numPadView.topAnchor, constant: -48),
            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupCategoryPicker() {
        var categories = [Category]()
        do {
            categories = try context.fetch(Category.fetchRequest())
        } catch {
            print("Could not fetch categories")
        }
        
        categoryPicker.setOptions(categories.map { $0.name ?? "Unknown" })
        view.addSubview(categoryPicker)
        
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.bottomAnchor.constraint(equalTo: numPadView.topAnchor, constant: -8),
            categoryPicker.heightAnchor.constraint(equalToConstant: 44),
            categoryPicker.widthAnchor.constraint(equalToConstant: 150)

        ])
        
    }
    
    func setupNumpad() {
        numPadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numPadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            numPadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            numPadView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            numPadView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        for i in 1...4 {
            let numPadChars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0"]
            let hStack = UIStackView()
            numPadView.addArrangedSubview(hStack)
                    
            hStack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hStack.leadingAnchor.constraint(equalTo: numPadView.leadingAnchor),
                hStack.trailingAnchor.constraint(equalTo: numPadView.trailingAnchor),
            ])
            
            hStack.distribution = .fillEqually
            hStack.spacing = 12
            
            for j in 1...3 {
                if ((i - 1) * 3 + j) > numPadChars.count {
                    let deleteButton = UIButton(type: .system)

                    let deleteSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
                    let deleteSymbol = UIImage(systemName: "delete.backward", withConfiguration: deleteSymbolConfiguration)
                    deleteButton.setImage(deleteSymbol, for: .normal)
                    deleteButton.tintColor = .label
                    deleteButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
                    
                    hStack.addArrangedSubview(deleteButton)
                }
                else {
                    let button = UIButton(type: .system)
                    hStack.addArrangedSubview(button)
                    button.setTitle(numPadChars[(i - 1) * 3 + j - 1], for: .normal)
                    button.titleLabel?.font = .systemFont(ofSize: 32)
                    button.setTitleColor(.label, for: .normal)
                    button.addTarget(self, action: #selector(numPadButtonPressed(sender:)), for: .touchUpInside)
                }
            }
        }
    }
    
    func setupAddTransactionButton() {
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTransactionButton.bottomAnchor.constraint(equalTo: numPadView.topAnchor, constant: -8),
            addTransactionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 50),
            addTransactionButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addTransaction() {
        let transaction = Transaction(context: context)
        transaction.amount = Double(amountLabel.text ?? "0") ?? 0.0
        transaction.date = Date()
        
        var categories = [Category]()
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            categories = try context.fetch(request)
        } catch let error {
            print("Error fetching: \(error)")
        }

        transaction.category = categories.first(where: { cat in
            cat.name == categoryPicker.currentTitle
        })
        
        do {
            try context.save()
        } catch {
            print("Could not save transaction")
        }
        
        amountLabel.text = ""
        newTransactionViewDelegate?.didAddTransaction()
    }
    
    @objc func numPadButtonPressed(sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        if let currentText = amountLabel.text, !currentText.isEmpty {
            if currentText.count < 8 {
                amountLabel.text! += buttonText
            } else {
                return
            }
        } else {
            amountLabel.text = buttonText
        }
    }
    
    @objc func backButtonPressed() {
        if let _ = amountLabel.text, !amountLabel.text!.isEmpty {
            amountLabel.text!.removeLast()
        }
    }
}
