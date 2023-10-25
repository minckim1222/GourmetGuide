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
    let dietaryHeaderView = GGTitleLabel(textAlignment: .left, text: "Diet")
    
    let dietaryStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    let veganView = GGDietaryView(button: GGDietaryButton(dietaryType: .vegan), label: GGBodyLabel(textAlignment: .center, text: "Vegan"))
    let vegetarianView = GGDietaryView(button: GGDietaryButton(dietaryType: .vegetarian), label: GGBodyLabel(textAlignment: .center, text: "No Meat"))
    let ketoView = GGDietaryView(button: GGDietaryButton(dietaryType: .keto), label: GGBodyLabel(textAlignment: .center, text: "Keto"))
    let glutenFree = GGDietaryView(button: GGDietaryButton(dietaryType: .glutenFree), label: GGBodyLabel(textAlignment: .center, text: "No Gluten"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        layoutUI()
        configureDietaryStackView()
        configureButtonStackView()
    }
    
    /// Lays out the UI and constrains views
    private func layoutUI() {
        view.addSubviews(searchField,dietaryHeaderView, buttonStackView)
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
            
            buttonStackView.topAnchor.constraint(equalTo: dietaryHeaderView.bottomAnchor, constant: padding),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            
        ])
    }
    
    /// Function that configures our Dietary stack view with button and label
    private func configureDietaryStackView(){
        view.addSubview(dietaryStackView)
        dietaryStackView.translatesAutoresizingMaskIntoConstraints = false
        dietaryStackView.addArrangedSubviews(veganView, vegetarianView, ketoView, glutenFree)
        dietaryStackView.distribution = .fillEqually
        dietaryStackView.spacing = 20
    }
    
    /// Function to configure the stackview that holds our buttons
    private func configureButtonStackView(){
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(dietaryStackView)
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
    }
    
}

