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
    
    private let categoryTextField: UITextField = {
        let categoryTextField = UITextField()
        categoryTextField.placeholder = "Category name"
        categoryTextField.font = .systemFont(ofSize: 32)
        return categoryTextField
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton(configuration: .filled())
        addCategoryButton.setTitle("Add category", for: .normal)
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        return addCategoryButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(categoryTextField)
        view.addSubview(addCategoryButton)
        
        setupCategoryTextField()
        setupAddCategoryButton()
    }
    
    override func viewDidLayoutSubviews() {
        addTextFieldUnderline()
    }
    
    func setupCategoryTextField() {
        view.addSubview(categoryTextField)

        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func addTextFieldUnderline() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, categoryTextField.frame.height - 1, categoryTextField.frame.width, 1.0)
        bottomLine.backgroundColor = UIColor.label.cgColor
        categoryTextField.layer.addSublayer(bottomLine)
    }
    
    @objc func addCategory() {
        let category = Category(context: context)
        category.name = categoryTextField.text

        do {
            try context.save()
        } catch {
            print("Could not save category")
        }
        
        dismiss(animated: true)
    }

}
