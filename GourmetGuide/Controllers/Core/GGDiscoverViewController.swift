//
//  ViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// ViewController to discover new recipes and search
class GGDiscoverViewController: UIViewController {
    
    let dietaryButton = GGDietaryButton(dietaryType: .vegetarian)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }

    private func configure() {
        view.addSubview(dietaryButton)
        NSLayoutConstraint.activate([
            dietaryButton.heightAnchor.constraint(equalToConstant: 75),
            dietaryButton.widthAnchor.constraint(equalToConstant: 75),
            dietaryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dietaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

}

