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
    
    /// Toast message to display what ingredient has been added
    private func showAddedIngredientToast(with ingredient: GGIngredient){
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 25, width: self.view.frame.size.width, height: 35))
        toastLabel.backgroundColor = .systemBackground.withAlphaComponent(0.6)
        toastLabel.textColor = .label
        toastLabel.font = UIFont.preferredFont(forTextStyle: .body)
        toastLabel.textAlignment = .center
        toastLabel.text = "\(ingredient.ingredient.capitalized) added to your ingredients."
        toastLabel.alpha = 1
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn) {
            toastLabel.alpha = 0.0
        } completion: { isCompleted in
            toastLabel.removeFromSuperview()
        }

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
//        if let index = availableIngredients.firstIndex(of: selectedIngredient) {
//            availableIngredients.remove(at: index)
//        }
        showAddedIngredientToast(with: selectedIngredient)
        delegate?.addedIngredient(ingredient: selectedIngredient)
        if var snapshot = self.datasource?.snapshot() {
            snapshot.deleteItems([selectedIngredient])
            datasource?.apply(snapshot)
        }
        tableView.deselectRow(at: indexPath, animated: false)
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
