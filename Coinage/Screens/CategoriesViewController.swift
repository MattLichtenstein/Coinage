//
//  CategoriesViewController.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/12/24.
//

import UIKit

class CategoriesViewController: UIViewController {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var categories = [Category]()
    let categoriesListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = [.top]

        setupTableView()
        setupAddCategoryButton()
        fetchCategories()
    }
    
    func setupAddCategoryButton() {
        let addCategoryButton = UIButton(configuration: .plain())
        view.addSubview(addCategoryButton)
        addCategoryButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addCategoryButton.setTitle("Add category", for: .normal)
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 18)
        addCategoryButton.configuration!.imagePadding = 12
        addCategoryButton.addTarget(self, action: #selector(presentAddCategoriesViewController), for: .touchUpInside)

        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 44)

        ])
    }
    
    func setupTableView() {
        view.addSubview(categoriesListTableView)
        
        categoriesListTableView.delegate = self
        categoriesListTableView.dataSource = self
        categoriesListTableView.register(CategoryListCell.self, forCellReuseIdentifier: "categoryCell")
        
        categoriesListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            categoriesListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func fetchCategories() {
        do {
            categories = try context.fetch(Category.fetchRequest())
        } catch {
            print("Could not fetch categories")
        }
    }
    
    @objc func presentAddCategoriesViewController() {
        let addCategoryVC = AddCategoryViewController()
        addCategoryVC.sheetPresentationController?.detents = [.large()]
        addCategoryVC.delegate = self
        
        present(addCategoryVC, animated: true, completion: nil)
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesListTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryListCell
        cell.setCategory(categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoriesViewController: AddCategoryViewDelegate {
    func didAddCategory() {
        fetchCategories()
        categoriesListTableView.reloadData()
    }
}
