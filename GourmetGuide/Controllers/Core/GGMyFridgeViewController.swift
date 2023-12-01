//
//  GGMyFridgeViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import UIKit

class GGMyFridgeViewController: UIViewController {

    private let ingredients = Bundle.main.decode([GGIngredient].self, from: "GGIngredients.json")
    
    private let ingredientTableView = UITableView()
    private let savedIngredientTableView = UITableView()
    private var savedIngredients: [GGIngredient] = []
    private var ingredientDataSource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    private var savedIngredientDataSource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTableview()
        configureIngredientDataSource()
        configureSavedIngredientDataSource()
        reloadIngredientDataSource()
        reloadSavedIngredientDataSource()
    }
    
    private func setUpTableview(){
        ingredientTableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 500)
        view.addSubview(ingredientTableView)
        view.addSubview(savedIngredientTableView)
        savedIngredientTableView.translatesAutoresizingMaskIntoConstraints = false
        savedIngredientTableView.delegate = self
        ingredientTableView.delegate = self
        ingredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        savedIngredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            savedIngredientTableView.topAnchor.constraint(equalTo: ingredientTableView.bottomAnchor, constant: 15),
            savedIngredientTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedIngredientTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedIngredientTableView.heightAnchor.constraint(equalToConstant: 500),
            savedIngredientTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func configureIngredientDataSource(){
        ingredientDataSource = GGIngredientDataSource(tableView: ingredientTableView, cellProvider: { [weak self] tableView, indexPath, ingredient in
            let cell = self?.ingredientTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell?.textLabel?.text = ingredient.ingredient
            return cell
        })
    }
    
    private func configureSavedIngredientDataSource(){
        savedIngredientDataSource = GGIngredientDataSource(tableView: savedIngredientTableView, cellProvider: { [weak self] tableView, indexPath, ingredient in
            let cell = self?.savedIngredientTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell?.textLabel?.text = ingredient.ingredient
            return cell
        })
    }
    
    private func reloadIngredientDataSource(){
        var snapshot = NSDiffableDataSourceSnapshot<GGIngredientSection, GGIngredient>()
        snapshot.appendSections([.availableIngredients])
        snapshot.appendItems(ingredients, toSection: .availableIngredients)
        ingredientDataSource?.apply(snapshot)
    }
    
    private func reloadSavedIngredientDataSource(){
        var snapshot = NSDiffableDataSourceSnapshot<GGIngredientSection, GGIngredient>()
        snapshot.appendSections([.myIngredients])
        snapshot.appendItems(savedIngredients, toSection: .myIngredients)
        savedIngredientDataSource?.apply(snapshot)
    }
}

/// Custom diffable data source
class GGIngredientDataSource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = snapshot().sectionIdentifiers[section]
        switch section {
        case .availableIngredients:
            return  "All Available Ingredients"
        case .myIngredients:
            return  "My Ingredients"
        }
    }
}

extension GGMyFridgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case ingredientTableView:
            guard let currentIngredient = ingredientDataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            
            guard var ingredientSnapshot = ingredientDataSource?.snapshot() else {
                return
            }
            guard var savedIngredientSnapshot = savedIngredientDataSource?.snapshot() else {
                return
            }
            savedIngredients.append(currentIngredient)
            savedIngredientSnapshot.appendItems([currentIngredient])
            ingredientSnapshot.deleteItems([currentIngredient])
            ingredientDataSource?.apply(ingredientSnapshot)
            savedIngredientDataSource?.apply(savedIngredientSnapshot)
        default:
            print("saved")
        }
        
//        snapshot.deleteItems([currentIngredient])
//        if !savedIngredients.contains(currentIngredient){
//            savedIngredients.append(currentIngredient)
//            snapshot.appendItems([currentIngredient], toSection: .myIngredients)
//        } else {
//            if let index = savedIngredients.firstIndex(of: currentIngredient) {
//                savedIngredients.remove(at: index)
//            }
//            snapshot.appendItems([currentIngredient], toSection: .availableIngredients)
//        }
//        print(savedIngredients)
//        ingredientDataSource?.apply(snapshot)
//        let cell = tableView.cellForRow(at: indexPath)
//        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
//            cell?.accessoryType = .checkmark
//            savedIngredients.append(ingredient)
//        } else {
//            cell?.accessoryType = .none
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum GGIngredientSection: CaseIterable {
    case availableIngredients
    case myIngredients
    
}
