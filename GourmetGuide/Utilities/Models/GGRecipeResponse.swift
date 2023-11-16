//
//  GGRecipeResponse.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/16/23.
//

import Foundation

struct GGRecipeResponse: Codable, Hashable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}
