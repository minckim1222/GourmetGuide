//
//  GGIngredientsResponseModel.swift
//  GourmetGuide
//
//  Created by Min Kim on 12/6/23.
//

import Foundation

// MARK: - WelcomeElement
struct GGIngredientResponse: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount, missedIngredientCount: Int
    let missedIngredients, usedIngredients, unusedIngredients: [SedIngredient]
    let likes: Int
}

// MARK: - SedIngredient
struct SedIngredient: Codable {
    let id, amount: Int
    let unit, unitLong, unitShort, aisle: String
    let name, original, originalName: String
    let meta: [String]
    let image: String
    let extendedName: String?
}
