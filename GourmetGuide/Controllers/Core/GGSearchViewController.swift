//
//  ViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// ViewController to discover new recipes and search
class GGSearchViewController: UIViewController {
    
    private let searchField = GGSearchTextField()
    private let dietaryHeaderView = GGTitleLabel(textAlignment: .left, text: "Search by Diet")
    private let mealTypeHeaderView = GGTitleLabel(textAlignment: .left, text: "Search by Meal Type")
   
    // Views for StackViews
    private let veganView = GGDietaryView(button: GGDietaryButton(dietaryType: .vegan), label: GGDietaryLabel(textAlignment: .center, text: "Vegan"))
    private let vegetarianView = GGDietaryView(button: GGDietaryButton(dietaryType: .vegetarian), label: GGDietaryLabel(textAlignment: .center, text: "No Meat"))
    private let ketoView = GGDietaryView(button: GGDietaryButton(dietaryType: .keto), label: GGDietaryLabel(textAlignment: .center, text: "Keto"))
    private let glutenFreeView = GGDietaryView(button: GGDietaryButton(dietaryType: .glutenFree), label: GGDietaryLabel(textAlignment: .center, text: "No Gluten"))
    private let breakfastView = GGDietaryView(button: GGDietaryButton(mealType: .breakfast), label: GGDietaryLabel(textAlignment: .center, text: "Breakfast"))
    private let mainCourseView = GGDietaryView(button: GGDietaryButton(mealType: .mainCourse), label: GGDietaryLabel(textAlignment: .center, text: "Main"))
    private let soupView = GGDietaryView(button: GGDietaryButton(mealType: .soup), label: GGDietaryLabel(textAlignment: .center, text: "Soup"))
    private let dessertView = GGDietaryView(button: GGDietaryButton(mealType: .dessert), label: GGDietaryLabel(textAlignment: .center, text: "Dessert"))
    
    // StackViews
    private let dietaryStackView = UIStackView()
    private let dietaryContainerStackView = UIStackView()
    private let mealTypeStackView = UIStackView()
    private let mealContainerStackView = UIStackView()
    
    // Recipes from API call
    private var recipes: [GGRecipeResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        layoutUI()
        createDismissTapGesture()
        configureStackViews()
        addTargetsToButtons()
        
    }
    
    /// Lays out the UI and constrains views
    private func layoutUI() {
        view.addSubviews(searchField,dietaryHeaderView, dietaryContainerStackView, mealTypeHeaderView, mealContainerStackView)
        let padding: CGFloat = 25
        searchField.delegate = self
        NSLayoutConstraint.activate([
            
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (padding)),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            
            dietaryHeaderView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: (padding)),
            dietaryHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dietaryHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dietaryHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            dietaryContainerStackView.topAnchor.constraint(equalTo: dietaryHeaderView.bottomAnchor, constant: padding),
            dietaryContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dietaryContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dietaryContainerStackView.heightAnchor.constraint(equalToConstant: 100),
            
            mealTypeHeaderView.topAnchor.constraint(equalTo: dietaryContainerStackView.bottomAnchor, constant: padding),
            mealTypeHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mealTypeHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            mealTypeHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            mealContainerStackView.topAnchor.constraint(equalTo: mealTypeHeaderView.bottomAnchor, constant: padding),
            mealContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mealContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            mealContainerStackView.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    /// Function that configures our Dietary stack view with button and label
    private func configureDietaryStackView(){
        view.addSubview(dietaryStackView)
        
        dietaryStackView.translatesAutoresizingMaskIntoConstraints = false
        dietaryStackView.addArrangedSubviews(veganView, vegetarianView, ketoView, glutenFreeView)
        dietaryStackView.distribution = .fillEqually
        dietaryStackView.spacing = 20
    }

    
    /// Function to configure the DietaryContainer
    private func configureDietaryContainer(){
        dietaryContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        dietaryContainerStackView.addArrangedSubview(dietaryStackView)
        dietaryContainerStackView.axis = .horizontal
        dietaryContainerStackView.distribution = .fillEqually
        dietaryContainerStackView.spacing = 10
    }
    
    /// Function that configures our MealType stack view with button and label
    private func configureMealTypeStackView(){
        view.addSubview(mealTypeStackView)
        
        mealTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        mealTypeStackView.addArrangedSubviews(breakfastView, mainCourseView, soupView, dessertView)
        mealTypeStackView.distribution = .fillEqually
        mealTypeStackView.spacing = 20
    }
    
    /// Function to configure MealType container
    private func configureMealTypeContainer(){
        mealContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        mealContainerStackView.addArrangedSubview(mealTypeStackView)
        mealContainerStackView.axis = .horizontal
        mealContainerStackView.distribution = .fillEqually
        mealContainerStackView.spacing = 10
    }
    
    /// Add target function to each button
    private func addTargetsToButtons(){
        let buttonArray = [
            veganView.button, vegetarianView.button, ketoView.button, glutenFreeView.button, mainCourseView.button, dessertView.button, soupView.button, breakfastView.button
        ]
        for button in buttonArray {
            button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        }
    }
    
    /// Function that makes an api call depending on what type of button was pressed
    /// - Parameter sender: Button pressed of either dietaryType or mealType
    @objc func actionButtonTapped(sender: GGDietaryButton){

        let queryParameters = [URLQueryItem(name: "diet", value: sender.dietaryValue)]
        let resultsVC = GGSearchResultsViewController()
        resultsVC.passedThroughQueryParameters = queryParameters
        resultsVC.passedThroughType = sender.dietaryValue
        self.navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    /// Configure all of the stackViews 
    private func configureStackViews(){
        configureDietaryStackView()
        configureDietaryContainer()
        configureMealTypeStackView()
        configureMealTypeContainer()
    }
    
    /// Function to add tap dismissal on search screen
    private func createDismissTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    /// Search function to get search field's text and query the API for recipes
    private func getRecipesFor(){
        guard let query = searchField.text else {
            return
        }
        let queryParameters = [URLQueryItem(name: "query", value: query)]
        let destinationVC = GGSearchResultsViewController()
        destinationVC.passedThroughQueryParameters = queryParameters
        destinationVC.passedThroughQuery = query
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension GGSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getRecipesFor()
        searchField.text = ""
        return true
    }
}
