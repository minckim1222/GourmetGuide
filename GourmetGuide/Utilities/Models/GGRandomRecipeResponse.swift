//
//  GGRandomRecipeResults.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/13/23.
//

import Foundation

/// Response model for random recipe api call
struct GGRandomRecipeResponse: Codable {
    let recipes: [GGRecipe]
}
