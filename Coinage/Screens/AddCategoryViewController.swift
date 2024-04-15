//
//  AddCategoryViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/12/24.
//

import UIKit

class AddCategoryViewController: UIViewController {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let categoryTextField: BorderedTextField = {
        let categoryTextField = BorderedTextField()
        categoryTextField.placeholder = "Category name"
        return categoryTextField
    }()
    private let categoryTypePicker = PickerButton(options: ["Expense", "Income", "Investment"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(categoryTextField)
        view.addSubview(categoryTypePicker)
        
        setupToolbar()
        setupCategoryTextField()
        setupCategoryTypePicker()
    }
    
    func setupToolbar() {
        let navigationBar = UINavigationBar()
        navigationBar.barTintColor = .systemBackground
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        view.addSubview(navigationBar)

        let navButtonCancel = UIBarButtonItem()
        navButtonCancel.tintColor = .label
        navButtonCancel.title = "Cancel"
        navButtonCancel.action = #selector(dismissView)

        let navButtonAdd = UIBarButtonItem()
        navButtonAdd.tintColor = .label
        navButtonAdd.title = "Add"
        navButtonAdd.action = #selector(addCategory)
        
        let navTitle = UINavigationItem(title: "Add category")
        navTitle.leftBarButtonItem = navButtonCancel
        navTitle.rightBarButtonItem = navButtonAdd
        
        navigationBar.items = [navTitle]
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupCategoryTextField() {
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupCategoryTypePicker() {
        view.addSubview(categoryTypePicker)
        
        categoryTypePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTypePicker.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            categoryTypePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTypePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTypePicker.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func addCategory() {
        let category = Category(context: context)
        category.name = categoryTextField.text
        category.type = (getCategoryType()).rawValue
                
        do {
            try context.save()
            NotificationCenter.default.post(name: .categoryAdded, object: nil)
        } catch {
            print("Could not save category")
        }
        
        dismiss(animated: true)
    }
    
    func getCategoryType() -> CategoryType {
//        guard let selectedOption = categoryTypePicker.selectedOption else { return expense }
        switch categoryTypePicker.selectedOption {
        case "Expense":
            return .expense
        case "Income":
            return .income
        case "Investment":
            return .investment
        default:
            return .expense
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}
