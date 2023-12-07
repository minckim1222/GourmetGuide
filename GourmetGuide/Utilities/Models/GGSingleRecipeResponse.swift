//
//  GGRecipeResponse.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/16/23.
//

import Foundation

/// Response model for Single recipe from API Call
struct GGSingleRecipeResponse: Codable, Hashable {
    let id: Int
    let title: String
    let image: String
}
