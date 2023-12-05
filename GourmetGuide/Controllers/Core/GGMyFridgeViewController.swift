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
    private var filteredIngredients: [GGIngredient] = []
    private var ingredientDataSource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    private var savedIngredientDataSource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTableview()
        configureSearchController()
        configureIngredientDataSource()
        configureSavedIngredientDataSource()
        reloadIngredientDataSource(with: ingredients)
        reloadSavedIngredientDataSource(with: savedIngredients)
    }
    
    private func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for an ingredient"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpTableview(){
        ingredientTableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 375)
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
            savedIngredientTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 60)
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
    
    private func reloadIngredientDataSource(with ingredients: [GGIngredient]){
        var snapshot = NSDiffableDataSourceSnapshot<GGIngredientSection, GGIngredient>()
        snapshot.appendSections([.availableIngredients])
        snapshot.appendItems(ingredients, toSection: .availableIngredients)
        ingredientDataSource?.apply(snapshot)
    }
    
    private func reloadSavedIngredientDataSource(with ingredients: [GGIngredient]){
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

/// Tableview protocol stubs for tapping on cells
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
            ingredientDataSource?.apply(ingredientSnapshot, animatingDifferences: true)
            savedIngredientDataSource?.apply(savedIngredientSnapshot, animatingDifferences: true)
        default:
            guard let savedIngredient = savedIngredientDataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            guard var savedIngredientSnapshot = savedIngredientDataSource?.snapshot() else {
                return
            }
            guard var availableIngredientSnapshot = ingredientDataSource?.snapshot() else {
                return
            }
            if let index = savedIngredients.firstIndex(of: savedIngredient) {
                savedIngredients.remove(at: index)
            }
            savedIngredientSnapshot.deleteItems([savedIngredient])
            availableIngredientSnapshot.appendItems([savedIngredient])
            ingredientDataSource?.apply(availableIngredientSnapshot, animatingDifferences: true)
            savedIngredientDataSource?.apply(savedIngredientSnapshot, animatingDifferences: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GGMyFridgeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filteredItems = searchController.searchBar.text, !filteredItems.isEmpty else { return }
        filteredIngredients = ingredients.filter({ $0.ingredient.lowercased().contains(filteredItems.lowercased()) })
        reloadIngredientDataSource(with: filteredIngredients)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        savedIngredients.removeAll()
        reloadIngredientDataSource(with: ingredients)
        reloadSavedIngredientDataSource(with: savedIngredients)
    }
}

enum GGIngredientSection {
    case availableIngredients
    case myIngredients
    
}
