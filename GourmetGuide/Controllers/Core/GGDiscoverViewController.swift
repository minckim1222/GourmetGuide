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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Discover"
        print(sections)
        print(dummyData.results.count)
        print(dummyData.results[0])
    }
}








let dummyItem = GGRecipe(vegetarian: false, vegan: false, glutenFree: false, dairyFree: false, creditsText: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceName: "Foodista", id: 638942, title: "Chocolate Chip Peanut Butter Mallow Dessert Bars", readyInMinutes: 45, servings: 8, sourceUrl: "http://www.foodista.com/recipe/832RWVP8/chocolate-chip-peanut-butter-mallow-bars", image: "https://spoonacular.com/recipeImages/638942-556x370.jpg", imageType: "jpg", summary: "Chocolate Chip Peanut Butter Mallow Dessert Bars takes approximately <b>45 minutes</b> from beginning to end. For <b>47 cents per serving</b>, you get a condiment that serves 8. One serving contains <b>277 calories</b>, <b>4g of protein</b>, and <b>14g of fat</b>. Only a few people made this recipe, and 2 would say it hit the spot. A mixture of egg, peanut butter, chocolate syrup, and a handful of other ingredients are all it takes to make this recipe so scrumptious. It is brought to you by Foodista. All things considered, we decided this recipe <b>deserves a spoonacular score of 15%</b>. This score is not so outstanding. If you like this recipe, take a look at these similar recipes: <a href=\"https://spoonacular.com/recipes/chocolate-chip-peanut-butter-mallow-dessert-bars-1367333\">Chocolate Chip Peanut Butter Mallow Dessert Bars</a>, <a href=\"https://spoonacular.com/recipes/chocolate-peanut-butter-mallow-bars-545182\">Chocolate-Peanut Butter Mallow Bars</a>, and <a href=\"https://spoonacular.com/recipes/peanut-butter-chocolate-chip-nutter-butter-bars-520662\">Peanut Butter Chocolate Chip Nutter Butter Bars</a>.", dishTypes: [], diets: [], instructions: "<ol><li>In a mixing bowl stir together the cookie mix, egg, milk and butter until smooth. Grease a 8x8 baking pan and spread the cookie mixture into the bottom. Bake in a 375 degree oven for about 15-20 minutes or until set and brown. Remove from the oven and spread on the peanut butter evenly on the top of the cookie bar then top with the marshmallows. Return the pan back into the oven just until the marshmallows start to melt. Take the pan back out of the oven and spread the marshmallows evenly over the peanut butter and then drizzle with the chocolate syrup. Let cool and cut into squares.</li></ol>", spoonacularSourceUrl: "https://spoonacular.com/chocolate-chip-peanut-butter-mallow-dessert-bars-638942")
let dummyArray = [dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem,dummyItem]
let dummyData = GGResponseModel(results: dummyArray, offset: 0, number: 1, totalResults: 10)
