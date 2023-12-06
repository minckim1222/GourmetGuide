//
//  GGAvailableIngredientsViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 12/6/23.
//

import UIKit

protocol GGAvailableIngredientsViewControllerDelegate: AnyObject {
    func addedIngredient(ingredient: GGIngredient)
}

class GGAvailableIngredientsViewController: UIViewController {

    public var availableIngredients: [GGIngredient] = []
    private var filteredIngredients: [GGIngredient] = []
    weak var delegate: GGAvailableIngredientsViewControllerDelegate?
    private var datasource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    private let availableIngredientTableView = UITableView()
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search Ingredients"
        configureTableView()
        configureDataSource()
        configureSearchController()
        reloadData(with: availableIngredients)
        
    }
    
    private func configureSearchController(){
            
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.placeholder = "Search for an ingredient"
        searchController.searchBar.returnKeyType = .search
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView(){
        view.addSubview(availableIngredientTableView)
        availableIngredientTableView.frame = view.bounds
        availableIngredientTableView.delegate = self
        availableIngredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureDataSource(){
        datasource = UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>(tableView: availableIngredientTableView, cellProvider: { tableView, indexPath, ingredient in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ingredient.ingredient
            return cell
        })
    }
    
    private func reloadData(with ingredients: [GGIngredient]){
        var snapshot = NSDiffableDataSourceSnapshot<GGIngredientSection, GGIngredient>()
        snapshot.appendSections([.availableIngredients])
        snapshot.appendItems(ingredients)
        DispatchQueue.main.async {
            self.datasource?.apply(snapshot)
        }
    }
    
}

//MARK: TableView Delegate Functions
extension GGAvailableIngredientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIngredient = datasource?.itemIdentifier(for: indexPath) else {
            return
        }
        if let index = availableIngredients.firstIndex(of: selectedIngredient) {
            availableIngredients.remove(at: index)
        }
        delegate?.addedIngredient(ingredient: selectedIngredient)
        reloadData(with: availableIngredients)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: SearchBar Delegate Functions
extension GGAvailableIngredientsViewController: UISearchResultsUpdating, UISearchBarDelegate, UITextFieldDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filteredItems = searchController.searchBar.text, !filteredItems.isEmpty else { return }
        filteredIngredients = availableIngredients.filter({
            $0.ingredient.lowercased().contains(filteredItems.lowercased()) })
        reloadData(with: filteredIngredients)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData(with: availableIngredients)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        reloadData(with: availableIngredients)
        return true
    }
}
