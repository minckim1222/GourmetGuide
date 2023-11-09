//
//  GGDiscoverViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import UIKit

/// Discovery controller with collectionView
class GGDiscoverViewController: UIViewController {
    
    let sections = Bundle.main.decode([GGDiscoverSection].self, from: "GGDiscoverSection.json")
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<GGDiscoverSection, GGRecipe>?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Discover"
        configureCollectionView()
        createDatasource()
        reloadData()
    }
    
    //MARK: Collection View
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GGFeaturedCollectionViewCell.self, forCellWithReuseIdentifier: GGFeaturedCollectionViewCell.reuseIdentifier)
        
        view.addSubview(collectionView)
    }
    
    /// Configure function for queueing cells
    /// - Parameters:
    ///   - cellType: Type of cell
    ///   - recipe: The recipe object to configure the cell with
    ///   - indexPath: IndexPath
    /// - Returns: A configured cell used for queueing
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with recipe: GGRecipe, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of type \(cellType)")
        }
        cell.configure(with: recipe)
        return cell
    }
    
    /// Function to create dataSource
    private func createDatasource(){
        dataSource = UICollectionViewDiffableDataSource<GGDiscoverSection, GGRecipe>(collectionView: collectionView, cellProvider: { collectionView, indexPath, recipe in
            switch self.sections[indexPath.section].type {
            default:
                return self.configure(GGFeaturedCollectionViewCell.self, with: recipe, for: indexPath)
            }
        })

    }
    
    /// Function to reload dataSource data
    private func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<GGDiscoverSection, GGRecipe>()
        snapshot.appendSections(sections)
        snapshot.appendItems(dummyArray)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot)
        }
    }
    
    //MARK: Compositional Layouts
    
    private func createFeaturedSection(using section: GGDiscoverSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

        return layoutSection
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            switch section.type {
            default:
                return self.createFeaturedSection(using: section)
            }
        }
        
        return layout
    }

}








let dummyItem = GGRecipe(vegetarian: false, vegan: false, glutenFree: false, dairyFree: true, creditsText: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceName: "Foodista", id: 638942, title: "Chocolate Chip Peanut Butter Mallow Dessert Bars", readyInMinutes: 45, servings: 8, sourceUrl: "http://www.foodista.com/recipe/832RWVP8/chocolate-chip-peanut-butter-mallow-bars", image: "https://spoonacular.com/recipeImages/638942-636x393.jpg", imageType: "jpg", summary: "Chocolate Chip Peanut Butter Mallow Dessert Bars takes approximately <b>45 minutes</b> from beginning to end. For <b>47 cents per serving</b>, you get a condiment that serves 8. One serving contains <b>277 calories</b>, <b>4g of protein</b>, and <b>14g of fat</b>. Only a few people made this recipe, and 2 would say it hit the spot. A mixture of egg, peanut butter, chocolate syrup, and a handful of other ingredients are all it takes to make this recipe so scrumptious. It is brought to you by Foodista. All things considered, we decided this recipe <b>deserves a spoonacular score of 15%</b>. This score is not so outstanding. If you like this recipe, take a look at these similar recipes: <a href=\"https://spoonacular.com/recipes/chocolate-chip-peanut-butter-mallow-dessert-bars-1367333\">Chocolate Chip Peanut Butter Mallow Dessert Bars</a>, <a href=\"https://spoonacular.com/recipes/chocolate-peanut-butter-mallow-bars-545182\">Chocolate-Peanut Butter Mallow Bars</a>, and <a href=\"https://spoonacular.com/recipes/peanut-butter-chocolate-chip-nutter-butter-bars-520662\">Peanut Butter Chocolate Chip Nutter Butter Bars</a>.", dishTypes: [], diets: [], instructions: "<ol><li>In a mixing bowl stir together the cookie mix, egg, milk and butter until smooth. Grease a 8x8 baking pan and spread the cookie mixture into the bottom. Bake in a 375 degree oven for about 15-20 minutes or until set and brown. Remove from the oven and spread on the peanut butter evenly on the top of the cookie bar then top with the marshmallows. Return the pan back into the oven just until the marshmallows start to melt. Take the pan back out of the oven and spread the marshmallows evenly over the peanut butter and then drizzle with the chocolate syrup. Let cool and cut into squares.</li></ol>", spoonacularSourceUrl: "https://spoonacular.com/chocolate-chip-peanut-butter-mallow-dessert-bars-638942")
let dummyItemTwo = GGRecipe(vegetarian: false, vegan: true, glutenFree: false, dairyFree: false, creditsText: "", sourceName: "", id: 2002, title: "Yo Momma Doe", readyInMinutes: 1, servings: 3, sourceUrl: "http://www.foodista.com/recipe/832RWVP8/chocolate-chip-peanut-butter-mallow-bars", image: "https://spoonacular.com/recipeImages/638942-556x370.jpg", imageType: "", summary: "ALSKDLAKSdAKLSD", dishTypes: [], diets: [], instructions: "", spoonacularSourceUrl: "")
let dummyItemThree = GGRecipe(vegetarian: true, vegan: true, glutenFree: false, dairyFree: false, creditsText: "", sourceName: "", id: 21312, title: "Yo Momma Doe", readyInMinutes: 1, servings: 3, sourceUrl: "http://www.foodista.com/recipe/832RWVP8/chocolate-chip-peanut-butter-mallow-bars", image: "https://spoonacular.com/recipeImages/638942-556x370.jpg", imageType: "", summary: "ALSKDLAKSdAKLSD", dishTypes: [], diets: [], instructions: "", spoonacularSourceUrl: "")
let dummyItemFour = GGRecipe(vegetarian: false, vegan: true, glutenFree: false, dairyFree: false, creditsText: "", sourceName: "", id: 435, title: "Yo Momma Doe", readyInMinutes: 1, servings: 3, sourceUrl: "http://www.foodista.com/recipe/832RWVP8/chocolate-chip-peanut-butter-mallow-bars", image: "https://spoonacular.com/recipeImages/638942-556x370.jpg", imageType: "", summary: "ALSKDLAKSdAKLSD", dishTypes: [], diets: [], instructions: "", spoonacularSourceUrl: "")
let dummyItemFive = GGRecipe(vegetarian: false, vegan: false, glutenFree: true, dairyFree: false, creditsText: "", sourceName: "", id: 6563, title: "Yo Momma Doe", readyInMinutes: 1, servings: 3, sourceUrl: "http://www.foodista.com/recipe/832RWVP8/chocolate-chip-peanut-butter-mallow-bars", image: "https://spoonacular.com/recipeImages/638942-556x370.jpg", imageType: "", summary: "ALSKDLAKSdAKLSD", dishTypes: [], diets: [], instructions: "", spoonacularSourceUrl: "")
let dummyArray = [dummyItem, dummyItemTwo, dummyItemThree, dummyItemFour, dummyItemFive]
let dummyData = GGResponseModel(results: dummyArray, offset: 0, number: 1, totalResults: 10)
