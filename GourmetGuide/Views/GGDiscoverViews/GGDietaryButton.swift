//
//  GGDietaryButton.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

/// Button to select dietary options
class GGDietaryButton: UIButton {
    
    public var dietaryType: String = ""
    public var dietaryValue: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Function to configure our button
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Initializer to specify which dietary type image to show
    /// - Parameter dietaryType: Raw value for dietary type passed in 
    init(dietaryType: GGDietType){
        super.init(frame: .zero)
        let dietaryImage = UIImage(named: dietaryType.rawValue)
        self.setImage(dietaryImage, for: .normal)
        self.dietaryType = "diet"
        self.dietaryValue = dietaryType.rawValue
        configure()
    }
    
    /// Initializer to specify which meal type image to show
    /// - Parameter mealType: Raw value for meal type passed in
    init(mealType: GGDishType){
        super.init(frame: .zero)
        let mealTypeImage = UIImage(named: mealType.rawValue)
        self.setImage(mealTypeImage, for: .normal)
        self.dietaryType = "type"
        self.dietaryValue = mealType.rawValue
        configure()
    }
    
}




