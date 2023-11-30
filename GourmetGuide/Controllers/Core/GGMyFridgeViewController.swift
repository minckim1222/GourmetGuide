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
    private var datasource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "My Refridgerator"
        setUpTableview()
        configureDataSource()
        reloadData()
    }
    
    private func setUpTableview(){
        ingredientTableView.frame = view.bounds
        view.addSubview(ingredientTableView)
        ingredientTableView.delegate = self
        ingredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    private func configureDataSource(){
        datasource = UITableViewDiffableDataSource(tableView: ingredientTableView, cellProvider: { [weak self ] tableView, indexPath, ingredient in
            
            let cell = self?.ingredientTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell?.textLabel?.text = ingredient.ingredient
            cell?.accessoryType = .none
            return cell
        })
    }
    
    private func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<GGIngredientSection, GGIngredient>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ingredients)
        datasource?.apply(snapshot)
    }
    
    
}

extension GGMyFridgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let ingredient = datasource?.itemIdentifier(for: indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

enum GGIngredientSection {
    case main
}
