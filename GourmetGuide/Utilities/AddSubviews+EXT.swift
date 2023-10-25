//
//  UIView+EXT.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// Extension on UIView to add multiple subviews at once
extension UIView {
    
    func addSubviews(_ views: UIView...){
        views.forEach { addSubview($0)}
    }
    
}

/// Extension on UIStackView to add multiple subviews at once
extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0)}
    }
    
}
