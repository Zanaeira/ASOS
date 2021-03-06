//
//  DetailViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 06/01/2022.
//

import UIKit
import ASOS

final class DetailViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let searchController = UISearchController()
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
    private lazy var dataSource: UICollectionViewDiffableDataSource<DetailViewControllerSection, Item> = makeDataSource()
    
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
        let sections: [DetailViewControllerSection] = [.announcements, .extraSales, .featuredAndGrid, .sales, .yourEdit, .recent]
        
        var snapshot = NSDiffableDataSourceSnapshot<DetailViewControllerSection, Item>()
        snapshot.appendSections(sections)
        snapshot.appendItems(items.filter({$0.section == .announcements}), toSection: .announcements)
        snapshot.appendItems(items.filter({$0.section == .extraSales}), toSection: .extraSales)
        let featuredGridItems = items.filter({$0.section == .featured}) + items.filter({$0.section == .grid})
        snapshot.appendItems(featuredGridItems, toSection: .featuredAndGrid)
        snapshot.appendItems(items.filter({$0.section == .sales}), toSection: .sales)
        snapshot.appendItems(items.filter({$0.section == .yourEdit}), toSection: .yourEdit)
        snapshot.appendItems(items.filter({$0.section == .recent}), toSection: .recent)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - Search Controller
private extension DetailViewController {
    
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
extension DetailViewController {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<DetailViewControllerSection, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let extraSalesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemGreen, leftColor: .systemTeal))
        }
        
        let featuredAndGridCellRegistration = UICollectionView.CellRegistration<FeaturedAndGridCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            if indexPath.item == 0 {
                cell.constrainHeightForFeatured()
            } else {
                cell.constrainHeightForGrid()
            }
        }
        
        let salesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemTeal, leftColor: .systemIndigo))
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
        
        let dataSource =  UICollectionViewDiffableDataSource<DetailViewControllerSection, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = self.dataSource.snapshot().sectionIdentifier(containingItem: itemIdentifier) else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
            
            switch section {
            case .announcements: return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            case .extraSales: return collectionView.dequeueConfiguredReusableCell(using: extraSalesCellRegistration, for: indexPath, item: itemIdentifier)
            case .featuredAndGrid: return collectionView.dequeueConfiguredReusableCell(using: featuredAndGridCellRegistration, for: indexPath, item: itemIdentifier)
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
    
    private var sectionHorizontalEdgeSpacing: CGFloat { 50.0 }
    private var interItemOrGroupSpacing: CGFloat { 16.0 }
    
    private func makeLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = interItemOrGroupSpacing

        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            guard let section = DetailViewControllerSection(rawValue: sectionNumber) else { return nil }
            switch section {
            case .announcements: return self.announcementsSection()
            case .extraSales: return self.salesSection()
            case .featuredAndGrid: return self.featuredAndGridSection()
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
        return standardSection(withTopSpacing: interItemOrGroupSpacing, itemHeight: height, groupHeight: height)
    }
    
    private func salesSection() -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .estimated(350)
        return standardSection(itemHeight: height, groupHeight: height)
    }
    
    private func featuredAndGridSection() -> NSCollectionLayoutSection {
        let leadingItemHeight: NSCollectionLayoutDimension = .estimated(1)
        let leadingItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: leadingItemHeight))
        leadingItem.contentInsets.trailing = interItemOrGroupSpacing
        
        let gridItemHeight: NSCollectionLayoutDimension = .estimated(1)
        let gridItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: gridItemHeight))
        
        let horizontalGroupHeight: NSCollectionLayoutDimension = .estimated(1)
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: horizontalGroupHeight), subitem: gridItem, count: 2)
        horizontalGroup.interItemSpacing = .fixed(interItemOrGroupSpacing)
        
        let verticalGroupHeight: NSCollectionLayoutDimension = .estimated(1)
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: verticalGroupHeight), subitems: [horizontalGroup, horizontalGroup])
        verticalGroup.interItemSpacing = .fixed(interItemOrGroupSpacing)
        
        let outerGroupHeight: NSCollectionLayoutDimension = .estimated(1)
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: outerGroupHeight), subitems: [leadingItem, verticalGroup])
        
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = .init(top: 0, leading: sectionHorizontalEdgeSpacing, bottom: 0, trailing: sectionHorizontalEdgeSpacing-interItemOrGroupSpacing)
        
        return section
    }
    
    private func yourEditSection() -> NSCollectionLayoutSection {
        let height: NSCollectionLayoutDimension = .estimated(350)
        return standardSection(itemHeight: height, groupHeight: height)
    }
    
    private func standardSection(withTopSpacing topSpacing: CGFloat = 0, itemHeight: NSCollectionLayoutDimension = .estimated(1), groupHeight: NSCollectionLayoutDimension = .estimated(1)) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: itemHeight), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: topSpacing, leading: sectionHorizontalEdgeSpacing, bottom: 0, trailing: sectionHorizontalEdgeSpacing)
        section.interGroupSpacing = interItemOrGroupSpacing
        
        return section
    }
    
    private func carouselSection() -> NSCollectionLayoutSection {
        var itemHeight: NSCollectionLayoutDimension = .estimated(250)
        
        let groupWidth: CGFloat
        
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory {
            if traitCollection.preferredContentSizeCategory < .accessibilityExtraLarge {
                groupWidth = 0.4
            } else {
                groupWidth = 0.3
            }
        } else {
            if traitCollection.preferredContentSizeCategory > .extraLarge {
                itemHeight = .estimated(400)
                groupWidth = 0.3
            } else {
                groupWidth = 0.2
            }
        }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: itemHeight)
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: interItemOrGroupSpacing, leading: sectionHorizontalEdgeSpacing, bottom: interItemOrGroupSpacing, trailing: sectionHorizontalEdgeSpacing)
        section.interGroupSpacing = interItemOrGroupSpacing
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        let backgroundDecorationItem = NSCollectionLayoutDecorationItem.background(elementKind: RecentlyViewedBackgroundDecorationView.sectionBackgroundDecorationElementKind)
        section.decorationItems = [backgroundDecorationItem]
        
        return section
    }
    
}
