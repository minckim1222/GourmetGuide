//
//  GGMainTabBarController.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/25/23.
//

import UIKit

class GGMainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTabs()
    }
    
    private func setUpTabs(){
        //create an instance of each VC
        let discoverVC = GGDiscoverViewController()
        let searchVC = GGSearchViewController()
        let myFridgeVC = GGMyFridgeViewController()
        let favoritesVC = GGFavoritesViewController()
        //for preferring large titles
        discoverVC.navigationItem.largeTitleDisplayMode = .automatic
        searchVC.navigationItem.largeTitleDisplayMode = .automatic
        myFridgeVC.navigationItem.largeTitleDisplayMode = .automatic
        favoritesVC.navigationItem.largeTitleDisplayMode = .automatic
        //create a nav controller w/ each VC
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let myFridgeNav = UINavigationController(rootViewController: myFridgeVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        //create a tab bar item for each of our Navs
        discoverNav.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "binoculars"), tag: 0)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        myFridgeNav.tabBarItem = UITabBarItem(title: "My Fridge", image: UIImage(systemName: "refrigerator"), tag: 0)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 0)
        //for each of the navs use a for loop to prefer large titles
        for nav in [discoverNav, searchNav, myFridgeNav, favoritesNav] {
            nav.navigationBar.prefersLargeTitles = true
        }
        //setViewControllers is the function that sets the tabs
        setViewControllers([discoverNav, searchNav, myFridgeNav, favoritesNav], animated: true)
    }
}
