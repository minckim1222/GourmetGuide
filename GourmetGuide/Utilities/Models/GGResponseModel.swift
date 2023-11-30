//
//  GGResponseModel.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import Foundation

/// Model for our API response
struct GGResponseModel: Codable {
    
    let results: [GGSingleRecipeResponse]
    let offset: Int
    let number: Int
    let totalResults: Int
}
