//
//  ViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// ViewController to discover new recipes and search
class GGSearchViewController: UIViewController {
    
    let searchField = GGSearchTextField()
    let dietaryHeaderView = GGTitleLabel(textAlignment: .left, text: "Search by Diet")
    let mealTypeHeaderView = GGTitleLabel(textAlignment: .left, text: "Search by Meal Type")
    
    let dietaryStackView = UIStackView()
    let dietaryContainerStackView = UIStackView()
    let mealTypeStackView = UIStackView()
    let mealContainerStackView = UIStackView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        layoutUI()
        configureStackViews()
        
    }
    
    /// Lays out the UI and constrains views
    private func layoutUI() {
        view.addSubviews(searchField,dietaryHeaderView, dietaryContainerStackView, mealTypeHeaderView, mealContainerStackView)
        let padding: CGFloat = 25
        
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
            
            mealTypeHeaderView.topAnchor.constraint(equalTo: dietaryContainerStackView.bottomAnchor, constant: 100),
            mealTypeHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mealTypeHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            mealTypeHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            mealContainerStackView.topAnchor.constraint(equalTo: mealTypeHeaderView.bottomAnchor, constant: padding),
            mealContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mealContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        ])
    }
    
    /// Function that configures our Dietary stack view with button and label
    private func configureDietaryStackView(){
        view.addSubview(dietaryStackView)
        let veganView = GGDietaryView(button: GGDietaryButton(dietaryType: .vegan), label: GGSummaryWebLabel(textAlignment: .center, text: "Vegan"))
        let vegetarianView = GGDietaryView(button: GGDietaryButton(dietaryType: .vegetarian), label: GGSummaryWebLabel(textAlignment: .center, text: "No Meat"))
        let ketoView = GGDietaryView(button: GGDietaryButton(dietaryType: .keto), label: GGSummaryWebLabel(textAlignment: .center, text: "Keto"))
        let glutenFreeView = GGDietaryView(button: GGDietaryButton(dietaryType: .glutenFree), label: GGSummaryWebLabel(textAlignment: .center, text: "No Gluten"))
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
        let breakfastView = GGDietaryView(button: GGDietaryButton(mealType: .breakfast), label: GGSummaryWebLabel(textAlignment: .center, text: "Breakfast"))
        let mainCourseView = GGDietaryView(button: GGDietaryButton(mealType: .mainCourse), label: GGSummaryWebLabel(textAlignment: .center, text: "Main"))
        let soupView = GGDietaryView(button: GGDietaryButton(mealType: .soup), label: GGSummaryWebLabel(textAlignment: .center, text: "Soup"))
        let dessertView = GGDietaryView(button: GGDietaryButton(mealType: .dessert), label: GGSummaryWebLabel(textAlignment: .center, text: "Dessert"))
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
    
    private func configureStackViews(){
        configureDietaryStackView()
        configureDietaryContainer()
        configureMealTypeStackView()
        configureMealTypeContainer()
    }
}

