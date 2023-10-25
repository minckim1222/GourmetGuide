//
//  GGTitleLabel.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// UILabel for titles
class GGTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Custom initializer for title label
    /// - Parameters:
    ///   - textAlignment: text alignment
    init(textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        configure()
    }
    
    /// Private configure file for our title labels}
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byTruncatingTail
        minimumScaleFactor = 0.9
        adjustsFontSizeToFitWidth = true
        textColor = .label
    }
}