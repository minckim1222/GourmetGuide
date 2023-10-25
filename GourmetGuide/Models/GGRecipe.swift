//
//  GGRecipe.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import Foundation

/// Model for single recipe
struct GGRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}
