//
//  GGIngredientsResponseModel.swift
//  GourmetGuide
//
//  Created by Min Kim on 12/6/23.
//

import Foundation

struct GGIngredientsResponseModel: Codable {
    let results: [GGSingleRecipeResponse]
}
