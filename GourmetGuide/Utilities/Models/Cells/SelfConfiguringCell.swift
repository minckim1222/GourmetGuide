//
//  SelfConfiguringCell.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/7/23.
//

import Foundation

/// Protocol for our compositional layout cells
protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with recipe: GGRecipe)
}

