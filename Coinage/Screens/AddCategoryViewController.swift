//
//  AddCategoryViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/12/24.
//

import UIKit

protocol AddCategoryViewDelegate {
    func didAddCategory()
}

class AddCategoryViewController: UIViewController {

    var delegate: AddCategoryViewDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let categoryTextField: TextField = {
        let categoryTextField = TextField()
        categoryTextField.placeholder = "Category name"
        return categoryTextField
    }()
    private let categoryTypeButton = PickerButton(options: ["Expense", "Income", "Investment"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(categoryTextField)
        view.addSubview(categoryTypeButton)
        
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
        view.addSubview(categoryTypeButton)
        
        categoryTypeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTypeButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            categoryTypeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTypeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTypeButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func addCategory() {
        let category = Category(context: context)
        category.name = categoryTextField.text

        do {
            try context.save()
            delegate?.didAddCategory()
        } catch {
            print("Could not save category")
        }
        
        dismiss(animated: true)
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}
