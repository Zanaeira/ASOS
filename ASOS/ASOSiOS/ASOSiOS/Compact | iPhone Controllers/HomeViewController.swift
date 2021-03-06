//
//  HomeViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit
import ASOS

final class HomeViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let searchController = UISearchController()
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = makeDataSource()
    
    private let itemLoader: ItemLoader
    private let itemUpdater: ItemUpdater
    private var items: [Item] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    init(itemLoader: ItemLoader, itemUpdater: ItemUpdater) {
        self.itemLoader = itemLoader
        self.itemUpdater = itemUpdater
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        configureHierarchy()
        loadItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configureHierarchy() {
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func loadItems() {
        itemLoader.loadItems(from: .init(string: "www.sample-url.com")!) { result in
            switch result {
            case .success(let loadedItems):
                self.items = loadedItems
            case .failure:
                fatalError("Failure has not been called in sample App.")
            }
        }
    }
    
    private func updateSnapshot() {
        let sections: [Section] = [.announcements, .extraSales, .featured, .grid, .special, .sales, .yourEdit, .recent]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            let sectionItems = items.filter { item in
                item.section == section
            }
            snapshot.appendItems(sectionItems, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - Search Controller
private extension HomeViewController {
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func dismissKeyboard() {
        searchController.isActive = false
    }
    
}

// MARK: - UICollectionView Helpers
extension HomeViewController {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let extraSalesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemGreen, leftColor: .systemTeal))
        }
        
        let featuredCellRegistration = UICollectionView.CellRegistration<ImageLabelsCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            cell.constrainHeightForFeatured()
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<ImageLabelsCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            cell.constrainHeightForGrid()
        }
        
        let salesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemTeal, leftColor: .systemIndigo))
        }
        
        let specialCellRegistration = UICollectionView.CellRegistration<ImageTextCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let yourEditCellRegistration = UICollectionView.CellRegistration<YourEditCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let recentlyViewedCellRegistration = UICollectionView.CellRegistration<RecentlyViewedCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            cell.onLikePressed = { liked in
                self.likePressed(forItemId: item.id.uuidString, liked: liked, onFail: {
                    cell.undoLikePressed()
                })
            }
        }
        
        let recentSectionHeaderRegistration = UICollectionView.SupplementaryRegistration<RecentlyViewedHeader>(elementKind: UICollectionView.elementKindSectionHeader) { (_, _, _) in }
        
        let dataSource =  UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = self.dataSource.snapshot().sectionIdentifier(containingItem: itemIdentifier) else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
            
            switch section {
            case .announcements: return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            case .extraSales: return collectionView.dequeueConfiguredReusableCell(using: extraSalesCellRegistration, for: indexPath, item: itemIdentifier)
            case .featured: return collectionView.dequeueConfiguredReusableCell(using: featuredCellRegistration, for: indexPath, item: itemIdentifier)
            case .grid: return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: itemIdentifier)
            case .special: return collectionView.dequeueConfiguredReusableCell(using: specialCellRegistration, for: indexPath, item: itemIdentifier)
            case .sales: return collectionView.dequeueConfiguredReusableCell(using: salesCellRegistration, for: indexPath, item: itemIdentifier)
            case .yourEdit: return collectionView.dequeueConfiguredReusableCell(using: yourEditCellRegistration, for: indexPath, item: itemIdentifier)
            case .recent: return collectionView.dequeueConfiguredReusableCell(using: recentlyViewedCellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: recentSectionHeaderRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    private func likePressed(forItemId itemId: String, liked: Bool, onFail: @escaping () -> Void) {
        itemUpdater.update(itemId: itemId, updateData: .init(itemLiked: liked)) { result in
            switch result {
            case .success(let items):
                self.items = items
            case .failure(let error):
                self.handleError(error)
                onFail()
            }
        }
    }
    
    private func handleError(_ error: Error) {
        let alert = UIAlertController(title: "An error occurred", message: "We were unable to save changes. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.dismiss(animated: false)
        present(alert, animated: true)
    }
    
    private var spacing: CGFloat { 16.0 }
    
    private func makeLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = spacing

        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionNumber) else { return nil }
            switch section {
            case .announcements: return self.announcementsSection()
            case .extraSales: return self.salesSection()
            case .featured: return self.featuredSection()
            case .grid: return self.gridSection()
            case .special: return self.specialSection()
            case .sales: return self.salesSection()
            case .yourEdit: return self.yourEditSection()
            case .recent: return self.carouselSection()
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        layout.register(RecentlyViewedBackgroundDecorationView.self, forDecorationViewOfKind: RecentlyViewedBackgroundDecorationView.sectionBackgroundDecorationElementKind)
        
        return layout
    }
    
    private func announcementsSection() -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .estimated(350)
        return standardSection(withTopSpacing: spacing, itemHeight: height, groupHeight: height)
    }
    
    private func salesSection() -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .estimated(350)
        return standardSection(itemHeight: height, groupHeight: height)
    }
    
    private func featuredSection() -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .estimated(450)
        return standardSection(itemHeight: height, groupHeight: height)
    }
    
    private func gridSection() -> NSCollectionLayoutSection {
        let itemHeight: NSCollectionLayoutDimension = .estimated(250)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
        
        let numOfColumns = traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? 1 : 2
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numOfColumns)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        section.interGroupSpacing = spacing
        
        return section
    }
    
    private func specialSection() -> NSCollectionLayoutSection {
        return featuredSection()
    }
    
    private func yourEditSection() -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .estimated(350)
        return standardSection(itemHeight: height, groupHeight: height)
    }
    
    private func standardSection(withTopSpacing topSpacing: CGFloat = 0, itemHeight: NSCollectionLayoutDimension = .estimated(1), groupHeight: NSCollectionLayoutDimension = .estimated(1)) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: itemHeight), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: topSpacing, leading: spacing, bottom: 0, trailing: spacing)
        section.interGroupSpacing = spacing
        
        return section
    }
    
    private func carouselSection() -> NSCollectionLayoutSection {
        let itemHeight: NSCollectionLayoutDimension = .estimated(250)
        
        let groupWidth: CGFloat
        
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory {
            if traitCollection.preferredContentSizeCategory < .accessibilityExtraLarge {
                groupWidth = 0.7
            } else {
                groupWidth = 0.8
            }
        } else {
            if traitCollection.preferredContentSizeCategory > .extraLarge {
                groupWidth = 0.6
            } else {
                groupWidth = 0.4
            }
        }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: itemHeight)
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        let backgroundDecorationItem = NSCollectionLayoutDecorationItem.background(elementKind: RecentlyViewedBackgroundDecorationView.sectionBackgroundDecorationElementKind)
        section.decorationItems = [backgroundDecorationItem]
        
        return section
    }
    
}
