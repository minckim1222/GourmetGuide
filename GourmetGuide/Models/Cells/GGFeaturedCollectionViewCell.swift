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
    private var vegan = false, vegetarian = false, glutenFree = false
    private var imageArray: [UIImageView] = []
    private let stackView = UIStackView()
    private let imageStackView = UIStackView()
    private var addMoreImage = true
    
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
        recipeName.numberOfLines = 1
        recipeImage.layer.cornerRadius = 5
        recipeImage.clipsToBounds = true
        recipeImage.contentMode = .scaleAspectFill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(recipeName, recipeImage)
        stackView.axis = .vertical
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.setCustomSpacing(10, after: recipeName)
    }
    
    /// Public func to configure our app
    /// - Parameter recipe: Recipe object to configure with
    public func configure(with recipe: GGRecipe) {
        recipeName.text = recipe.title
        recipeImage.downloadImage(from: recipe.image)
    }

}
