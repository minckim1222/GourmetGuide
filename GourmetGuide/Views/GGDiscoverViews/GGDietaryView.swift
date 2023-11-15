//
//  GGDietaryView.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import UIKit

/// View that holds our dietary button + label
class GGDietaryView: UIView {

    let verticalStackView = UIStackView()
    var button = GGDietaryButton()
    var label = GGSummaryWebLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializer for dietary button
    init(button: GGDietaryButton, label: GGSummaryWebLabel){
        super.init(frame: .zero)
        self.button = button
        self.label = label
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        configureStackView()
        layoutConstraints()
    }
    
    /// Vertical stackview that holds button and label underneath
    private func configureStackView(){
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubviews(button, label)
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        
    }
    
    /// Constrains the button and label by giving sizes
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 73.5),
            button.heightAnchor.constraint(equalToConstant: 73.5),
            
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
}
