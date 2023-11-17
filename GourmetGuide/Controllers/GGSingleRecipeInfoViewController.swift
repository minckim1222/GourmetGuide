//
//  SingleRecipeInfoViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/14/23.
//

import UIKit

class GGSingleRecipeInfoViewController: UIViewController {

    public var recipe: GGRecipe!
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = GGTitleLabel()
    private let summaryLabel = UITextView()
    private var vegan = false
    private var vegetarian = false
    private var glutenFree = false
    private var dietaryStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureScrollView()
        configureDietaryLabels()
        print("Vegan: \(vegan)")
        print("Vegetaria: \(vegetarian)")
        print("GlutenFree: \(glutenFree)")
    }
    
    init(recipe: GGRecipe){
        self.recipe = recipe
        self.vegan = recipe.vegan
        self.vegetarian = recipe.vegetarian
        self.glutenFree = recipe.glutenFree
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        contentView.addSubviews(imageView, titleLabel, summaryLabel, dietaryStackView)
        configureImageView()
        configureTitleLabel()
        configureSummaryLabel()
        configureDietaryLabelStackView()
    }
    
    private func configureTitleLabel(){
        titleLabel.text = recipe.title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func configureImageView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.downloadImage(from: recipe.image)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureSummaryLabel(){
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.attributedText = recipe.summary.convertToHtml()
        
        summaryLabel.textColor = .label
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: dietaryStackView.bottomAnchor, constant: 25),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            summaryLabel.heightAnchor.constraint(equalToConstant: 250),
            summaryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureDietaryLabels(){
        if vegetarian {
            let view = GGDietaryView(button: .init(dietaryType: .vegetarian), label: .init(textAlignment: .center, text: "Vegetarian"))
            dietaryStackView.addArrangedSubview(view)
        }
        if vegan {
            let view = GGDietaryView(button: .init(dietaryType: .vegan), label: .init(textAlignment: .center, text: "Vegan"))
            dietaryStackView.addArrangedSubview(view)
        }
        if glutenFree {
            let view = GGDietaryView(button: .init(dietaryType: .glutenFree), label: .init(textAlignment: .center, text: "Gluten Free"))
            dietaryStackView.addArrangedSubview(view)
        }
        if !vegan && !vegetarian {
            let view = GGDietaryView(button: .init(dietaryType: .keto), label: .init(textAlignment: .center, text: "Meat Based"))
            dietaryStackView.addArrangedSubview(view)
        }
        dietaryStackView.addArrangedSubview(UIView())
        dietaryStackView.addArrangedSubview(UIView())
        
    }
    
    private func configureDietaryLabelStackView(){
        dietaryStackView.translatesAutoresizingMaskIntoConstraints = false
        dietaryStackView.distribution = .fillEqually

        NSLayoutConstraint.activate([
            dietaryStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            dietaryStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dietaryStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dietaryStackView.heightAnchor.constraint(equalToConstant: 75)
        ])
                
    }
    
    private func configureDietaryLabelImageView(for dietType: GGDietType) -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: dietType.rawValue)
        imageView.makeRounded()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
}
