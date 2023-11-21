//
//  GGSearchResultsViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/16/23.
//

import UIKit

class GGSearchResultsViewController: UIViewController {
    
    let sections = Bundle.main.decode([GGDiscoverSection].self, from: "GGDiscoverSection.json")
    public var recipesArray: [GGRecipeResponse] = []
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<GGDiscoverSection, GGRecipeResponse>?
    public var dietaryType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search Results"
        configureCollectionView()
        createDataSource()
        reloadData()
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(GGSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: GGSearchResultCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<GGDiscoverSection, GGRecipeResponse>(collectionView: collectionView, cellProvider: { collectionView, indexPath, recipe in
            switch self.sections[indexPath.section].type {
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GGSearchResultCollectionViewCell.reuseIdentifier, for: indexPath) as? GGSearchResultCollectionViewCell else {
                    fatalError("Could not dequeue cell")
                }
                cell.configure(with: recipe)
                return cell
            }
        })
    }
//    
    private func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<GGDiscoverSection, GGRecipeResponse>()
        snapshot.appendSections(sections)
        snapshot.appendItems(recipesArray)
        DispatchQueue.main.async{
            self.dataSource?.apply(snapshot)
        }
    }
    //MARK: Compositional Layouts
    
    private func createFeaturedSection(using section: GGDiscoverSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 15, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

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

extension GGSearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        GGService.shared.getSingleRecipe(from: .singleRecipe, with: item.id) { result in
            switch result {
            case .success(let recipe):
                DispatchQueue.main.async{
                    let recipeVC = GGSingleRecipeInfoViewController(recipe: recipe)
                    self.navigationController?.pushViewController(recipeVC, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
