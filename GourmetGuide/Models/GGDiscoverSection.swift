//
//  GGDiscoverSection.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/7/23.
//

import Foundation

/// Struct that holds model for Compositional Layout Section
struct GGDiscoverSection: Codable, Hashable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
}
