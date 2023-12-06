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
    private var datasource: UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>?
    public var myIngredients: [GGIngredient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "My Ingredients"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAvailableIngredients))
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
    
    private func configureTableView(){
        view.addSubview(myIngredientTableView)
        myIngredientTableView.frame = view.bounds
        myIngredientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myIngredientTableView.delegate = self
    }
    
    //Configure the diffable data source
    private func configureMyIngredientDataSource(){
        datasource = UITableViewDiffableDataSource<GGIngredientSection, GGIngredient>(tableView: myIngredientTableView, cellProvider: { tableView, indexPath, ingredient in
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
        print("Selected")
    }
}

extension GGMyFridgeViewController: GGAvailableIngredientsViewControllerDelegate {
    func addedIngredient(ingredient: GGIngredient) {
        self.myIngredients.append(ingredient)
        if let index = mutatableIngredients.firstIndex(of: ingredient) {
            mutatableIngredients.remove(at: index)
        }
        self.reloadDataSource(with: myIngredients)
    }
}

enum GGIngredientSection {
    case myIngredients
    case availableIngredients
}
