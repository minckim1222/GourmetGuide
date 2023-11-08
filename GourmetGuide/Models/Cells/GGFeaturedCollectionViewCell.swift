//
//  GGFeaturedCollectionViewCell.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/7/23.
//

import UIKit

/// CollectionView cell for Featured section of CompLayout
class GGFeaturedCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
        
    static let reuseIdentifier = "GGFeaturedCollectionViewCell"
    private let recipeName = UILabel()
    private let recipeImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .quaternaryLabel
        
        recipeName.font = UIFont.preferredFont(forTextStyle: .title1)
        recipeName.textColor = .systemBlue
        
        recipeImage.layer.cornerRadius = 5
        recipeImage.clipsToBounds = true
        recipeImage.contentMode = .scaleAspectFit
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(seperator, recipeName, recipeImage)
        stackView.axis = .vertical
        contentView.addSubview(stackView)
    }
    
    public func configure(with recipe: GGRecipe) {
        recipeName.text = recipe.title
        recipeImage.downloadImage(from: recipe.image)
    }
}
