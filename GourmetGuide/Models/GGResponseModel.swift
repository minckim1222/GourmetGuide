//
//  GGResponseModel.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import Foundation

/// Model for our API response
struct GGResponseModel: Codable {
    
    let recipes: [GGRecipe]
    
}
