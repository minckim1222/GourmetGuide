//
//  GGSearchResultsViewController.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/16/23.
//

import UIKit

class GGSearchResultsViewController: UIViewController {
    
    private let sections = Bundle.main.decode([GGDiscoverSection].self, from: "GGDiscoverSection.json")
    private var offset = 0
    public var passedThroughQueryParameters: [URLQueryItem] = []
    public var passedThroughType = ""
    public var passedThroughQuery = ""
    private var searchParameters: [URLQueryItem] = []
    private var showMoreRecipes = true
    private var parameters: [URLQueryItem] = []
    public var recipesArray: [GGRecipeResponse] = []
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<GGDiscoverSection, GGRecipeResponse>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search Results"
        configureCollectionView()
        createDataSource()
        loadInitialData(withParameters: passedThroughQueryParameters)
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
    //MARK: CollectionView data
    
    private func loadInitialData(withParameters parameters: [URLQueryItem]){
        GGService.shared.getDietaryRecipes(from: .dietaryRecipes, withParameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                self.recipesArray.append(contentsOf: recipes)
                self.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadMoreData(withParameters parameters: [URLQueryItem]){
        if !passedThroughType.isEmpty {
            searchParameters = [URLQueryItem(name: "diet", value: passedThroughType), URLQueryItem(name: "offset", value: String(offset))]
        } else if !passedThroughQuery.isEmpty {
            searchParameters = [URLQueryItem(name: "query", value: passedThroughQuery), URLQueryItem(name: "offset", value: String(offset))]
        }
        print(searchParameters)
        GGService.shared.getDietaryRecipes(from: .dietaryRecipes, withParameters: searchParameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                if recipes.count < 10 {
                    showMoreRecipes = false
                }
                self.recipesArray.append(contentsOf: recipes)
                self.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            guard showMoreRecipes else { return }
            offset += 10
            loadMoreData(withParameters: parameters)
        }
        
    }
}
