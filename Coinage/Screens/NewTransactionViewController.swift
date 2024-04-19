//
//  NewTransactionViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/5/24.
//

import CoreData
import UIKit

final class NewTransactionViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var categories: [Category] = []
    
    private var amountValue = "0" {
        didSet {
            amountLabel.text = "$" + amountValue
        }
    }
    
    private lazy var amountLabel: UILabel = {
        let font = UIFont(name: Constants.FontFamily.cmMediumRounded, size:  64)
        let amountLabel = UILabel()
        amountLabel.font = UIFontMetrics.default.scaledFont(for: font!)
        amountLabel.adjustsFontForContentSizeCategory = true
        amountLabel.text = "$" + amountValue

        return amountLabel
    }()
    
    private lazy var descriptionField: PlainTextField = {
        let descriptionField = PlainTextField()
        descriptionField.placeholder = "Description"
        descriptionField.autocorrectionType = .no
        descriptionField.spellCheckingType = .no
        descriptionField.delegate = self
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.closeKeyboard))
        toolbar.setItems([space, doneButton], animated: true)
        toolbar.sizeToFit()
        descriptionField.inputAccessoryView = toolbar
        return descriptionField
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let addTransactionButton = UIButton()
        addTransactionButton.setTitle("Add", for: .normal)
        addTransactionButton.backgroundColor = .secondarySystemBackground
        addTransactionButton.setTitleColor(.label, for: .normal)
        addTransactionButton.layer.cornerRadius = 10
        let font = UIFont(name: Constants.FontFamily.cmRegularRounded, size: CGFloat(Constants.FontSize.paragraph))!
        addTransactionButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: font)
        addTransactionButton.titleLabel?.adjustsFontForContentSizeCategory = true
        addTransactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        return addTransactionButton
    }()
    
    private lazy var numPadView: UIStackView = {
        let numPadView = UIStackView()
        numPadView.axis = .vertical
        numPadView.distribution = .fillEqually
        numPadView.spacing = 12
        return numPadView
    }()
    
    private lazy var categoryPicker = PickerButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = []
        
        view.addSubview(amountLabel)
        view.addSubview(descriptionField)
        view.addSubview(addTransactionButton)
        view.addSubview(numPadView)
        view.addSubview(categoryPicker)
        
        setupAmountLabel()
        setupDescriptionField()
        setupCategoryPicker()
        setupAddTransactionButton()
        setupNumpad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(categoryAdded), name: .categoryAdded, object: nil)
    }
    
    func setupAmountLabel() {
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupDescriptionField() {
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            descriptionField.bottomAnchor.constraint(equalTo: categoryPicker.topAnchor, constant: -12)
        ])
    }
    
    func setupCategoryPicker() {
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.bottomAnchor.constraint(equalTo: numPadView.topAnchor, constant: -8),
            categoryPicker.heightAnchor.constraint(equalToConstant: 44),
            categoryPicker.widthAnchor.constraint(equalToConstant: 150)

        ])
        
        fetchCategories()
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
                    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(backButtonLongPressed))
                    deleteButton.addGestureRecognizer(longPressGestureRecognizer)
                    
                    hStack.addArrangedSubview(deleteButton)
                }
                else {
                    let button = UIButton(type: .system)
                    hStack.addArrangedSubview(button)
                    button.setTitle(numPadChars[(i - 1) * 3 + j - 1], for: .normal)
                    button.titleLabel?.font = UIFont(name: Constants.FontFamily.cmRegularRounded, size: 32)
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
    
    func fetchCategories() {
        do {
            categories = try context.fetch(Category.fetchRequest())
        } catch {
            print("Could not fetch categories")
        }
        
        setCategories()
    }
    
    func setCategories() {
        categoryPicker.setOptions(categories.map { $0.name ?? "Unknown category" })
    }
    
    @objc
    func addTransaction() {
        let transaction = Transaction(context: context)
        transaction.name = descriptionField.text?.isEmpty == false ? descriptionField.text! : "--"
        transaction.amount = Double(amountValue) ?? 0.0
        transaction.timestamp = Date()
                
        var categories = [Category]()
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            categories = try context.fetch(request)
        } catch let error {
            print("Error fetching: \(error)")
        }

        transaction.category = categories.first(where: { cat in
            cat.name == categoryPicker.configuration?.title
        })
                
        do {
            try context.save()
        } catch {
            print("Could not save transaction \(error)")
        }
        
        amountValue = "0"
        descriptionField.text = ""
        NotificationCenter.default.post(name: .transactionListChanged, object: nil)
    }
    
    @objc
    func numPadButtonPressed(sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        if amountValue == "0" {
            amountValue = buttonText
        }
        else {
            amountValue += buttonText
        }
    }
    
    @objc
    func backButtonPressed() {
        if amountValue.count > 1 {
            amountValue.removeLast()
        }
        else if amountValue == "0" {
            amountLabel.transform = CGAffineTransform(translationX: 20, y: 0)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.amountLabel.transform = CGAffineTransform.identity
            })
        }
        else {
            amountValue = "0"
        }
    }
    
    @objc
    func backButtonLongPressed() {
        amountValue = "0"
    }
    
    @objc
    func categoryAdded() {
        fetchCategories()
    }
}

extension NewTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionField.endEditing(true)
    }
}
