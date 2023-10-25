//
//  UIImageView+EXT.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

extension UIImageView {
    
    /// Function to make UIImageView a circle
    func makeRounded() {
        
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
