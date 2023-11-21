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
    var randomRecipesArray: [GGRecipe] = []
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
        collectionView.delegate = self
        view.addSubview(collectionView)
        showLoadingView()
        GGService.shared.getRandomRecipes(from: .randomRecipes) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                self.randomRecipesArray = recipes
                self.reloadData()
            case .failure(let error):
                print(error)
            }
            dismissLoadingView()
        }
        
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
        snapshot.appendItems(randomRecipesArray)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    //MARK: Compositional Layouts
    
    private func createFeaturedSection(using section: GGDiscoverSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

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
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 100
        layout.configuration = config
        return layout
    }

}

extension GGDiscoverViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        let destinationVC = GGSingleRecipeInfoViewController(recipe: item)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
