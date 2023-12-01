//
//  GGIngredient.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/30/23.
//

import Foundation

/// Model for ingredients for API calls
struct GGIngredient: Codable, Hashable {
    let ingredient: String
    let id: Int
    var saved: Bool
}
