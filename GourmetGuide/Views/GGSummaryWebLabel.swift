//
//  GGBodyLabel.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// UILabel for titles
class GGSummaryWebLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Custom initializer for title label
    /// - Parameters:
    ///   - textAlignment: Text Alignment
    ///   - text: Text to display
    init(textAlignment: NSTextAlignment,text: String){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.text = text
        self.font = UIFont.preferredFont(forTextStyle: .body)
        configure()
    }
    
    /// Private configure file for our title labels}
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byWordWrapping
        minimumScaleFactor = 0.75
        numberOfLines = 0
        isUserInteractionEnabled = true
    }
}
