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
    private let imageStackView = UIStackView()
    private let dietaryStackView = UIStackView()
    
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
        recipeName.textColor = .label
        recipeName.numberOfLines = 1
        recipeImage.layer.cornerRadius = 5
        recipeImage.clipsToBounds = true
        recipeImage.contentMode = .scaleAspectFill
        configureImageStackView()

    }
    
    /// Function configures the stackView for our title and image
    private func configureImageStackView(){
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.addArrangedSubviews(recipeName, recipeImage)
        imageStackView.axis = .vertical
        imageStackView.alignment = .leading
        contentView.addSubview(imageStackView)
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        imageStackView.setCustomSpacing(10, after: recipeName)
    }

    /// Public func to configure our app
    /// - Parameter recipe: Recipe object to configure with
    public func configure(with recipe: GGRecipe) {
        recipeName.text = recipe.title
        recipeImage.downloadImage(from: recipe.image)
    }

}
