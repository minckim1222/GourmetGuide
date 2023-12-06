//
//  GGMyFridgeViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import UIKit


class GGMyFridgeViewController: UIViewController {
    
    
    private let defaultIngredients = Bundle.main.decode([GGIngredient].self, from: "GGIngredients.json")
    private var mutatableIngredients = Bundle.main.decode([GGIngredient].self, from: "GGIngredients.json")
    private let myIngredientTableView = UITableView()
    private var datasource: DataSource?
    public var myIngredients: [GGIngredient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "My Ingredients"
        let addIngredientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAvailableIngredients))
        let searchRecipesButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchRecipes))
        navigationItem.rightBarButtonItems = [searchRecipesButton, addIngredientButton]
        configureTableView()
        configureMyIngredientDataSource()
        reloadDataSource(with: myIngredients)
    }
    
    @objc func showAvailableIngredients(){
        let availableIngredientsVC = GGAvailableIngredientsViewController()
        availableIngredientsVC.availableIngredients = mutatableIngredients
        availableIngredientsVC.delegate = self
        let destinationVC = UINavigationController(rootViewController: availableIngredientsVC )
        destinationVC.navigationBar.prefersLargeTitles = true
        present(destinationVC, animated: true)
    }
    
    @objc func searchRecipes(){
        let ingredientsToQuery = myIngredients.map { $0.ingredient }
        GGService.shared.getRecipesWithIngredients(from: .withIngredients, with: ingredientsToQuery) { [weak self] result in
            switch result {
            case .success(let recipes):
                print(recipes)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureTableView(){
        view.addSubview(myIngredientTableView)
        myIngredientTableView.frame = view.bounds
        myIngredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myIngredientTableView.delegate = self
    }
    
    //Configure the diffable data source
    private func configureMyIngredientDataSource(){
        datasource = DataSource(tableView: myIngredientTableView, cellProvider: { tableView, indexPath, ingredient in
            let cell = self.myIngredientTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ingredient.ingredient
            return cell
        })
        
    }
    
    //Reload the data source
    private func reloadDataSource(with ingredients: [GGIngredient]){
        var snapshot = NSDiffableDataSourceSnapshot<GGIngredientSection, GGIngredient>()
        snapshot.appendSections([.myIngredients])
        snapshot.appendItems(ingredients)
        DispatchQueue.main.async{
            self.datasource?.apply(snapshot)
        }
        
    }
    
}

extension GGMyFridgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let ingredient = datasource?.itemIdentifier(for: indexPath) else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let ingredient = datasource?.itemIdentifier(for: indexPath) else {
            return
        }
        if let index = myIngredients.firstIndex(of: ingredient){
            myIngredients.remove(at: index)
        }
    }
}

extension GGMyFridgeViewController: GGAvailableIngredientsViewControllerDelegate {
    func addedIngredient(ingredient: GGIngredient) {
        print(ingredient)
        if !myIngredients.contains(ingredient) {
            self.myIngredients.append(ingredient)
        }
        if let index = mutatableIngredients.firstIndex(of: ingredient) {
            mutatableIngredients[index].saved = true
            print(mutatableIngredients[index])
        }
        
        self.reloadDataSource(with: myIngredients)
    }
}

enum GGIngredientSection {
    case myIngredients
    case availableIngredients
}

class DataSource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        var snapshot = self.snapshot()
        if let ingredient = self.itemIdentifier(for: indexPath) {
            snapshot.deleteItems([ingredient])
            self.apply(snapshot)
        }
        
    }
}
