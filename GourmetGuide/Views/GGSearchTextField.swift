//
//  GGSearchTextField.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import UIKit

/// Text field for our search
class GGSearchTextField: UITextField {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        adjustsFontSizeToFitWidth = true
        autocorrectionType = .yes
        placeholder = "Search recipes"
    }
    
}
