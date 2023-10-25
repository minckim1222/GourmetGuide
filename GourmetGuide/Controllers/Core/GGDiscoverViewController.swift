//
//  ViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// ViewController to discover new recipes and search
class GGDiscoverViewController: UIViewController {
    
    
    
    let vegetarianButton = GGDietaryButton(dietaryType: .vegetarian)
    let veganButotn = GGDietaryButton(dietaryType: .vegan)
    let ketoButton = GGDietaryButton(dietaryType: .keto)
    let glutenFreeButton = GGDietaryButton(dietaryType: .glutenFree)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }

    private func configure() {
        view.addSubview(vegetarianButton)
        NSLayoutConstraint.activate([
            vegetarianButton.heightAnchor.constraint(equalToConstant: 75),
            vegetarianButton.widthAnchor.constraint(equalToConstant: 75),
            vegetarianButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vegetarianButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

}

