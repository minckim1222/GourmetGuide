//
//  ViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// ViewController to discover new recipes and search
class GGDiscoverViewController: UIViewController {
    
    let dietaryHeaderView = GGTitleLabel(textAlignment: .left, text: "Dietary Restrictions")
    
    let vegetarianButton = GGDietaryButton(dietaryType: .vegetarian)
    let veganButton = GGDietaryButton(dietaryType: .vegan)
    let ketoButton = GGDietaryButton(dietaryType: .keto)
    let glutenFreeButton = GGDietaryButton(dietaryType: .glutenFree)
    
    let buttonStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        configureStackView()
    }
    
    /// Lays out the UI and constrains views
    private func layoutUI() {
        view.addSubviews(dietaryHeaderView, buttonStackView)
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            dietaryHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (padding * 2)),
            dietaryHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dietaryHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dietaryHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStackView.topAnchor.constraint(equalTo: dietaryHeaderView.bottomAnchor, constant: padding),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            buttonStackView.heightAnchor.constraint(equalToConstant: 73.5)
            
        ])
    }
    
    /// Function to configure the stackview that holds our buttons
    private func configureStackView(){
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubviews(vegetarianButton, veganButton, ketoButton, glutenFreeButton)
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
    }
    
}

