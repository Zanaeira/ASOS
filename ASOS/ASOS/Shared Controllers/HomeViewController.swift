//
//  HomeViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        updateSnapshot()
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
    
    private func updateSnapshot() {
        let sections: [Section] = [.announcements, .extraSales, .featured, .grid]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach({snapshot.appendItems(Section.items(forSection: $0), toSection: $0)})
        
        dataSource.apply(snapshot, animatingDifferences: true)
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
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<ImageLabelsCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            cell.constrainHeightForGrid()
        }
        
        let salesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemTeal, leftColor: .systemIndigo))
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
            case .special: return nil
            case .sales: return collectionView.dequeueConfiguredReusableCell(using: salesCellRegistration, for: indexPath, item: itemIdentifier)
            case .yourEdit: return nil
            case .recent: return nil
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: recentSectionHeaderRegistration, for: indexPath)
        }
        
        return dataSource
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
        
        return section
    }
    
    private func specialSection() -> NSCollectionLayoutSection {
        return standardSection()
    }
    
    private func yourEditSection() -> NSCollectionLayoutSection {
        return standardSection()
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
        let itemHeight: NSCollectionLayoutDimension = .estimated(1)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: itemHeight)
        
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

private extension UICollectionViewListCell {
    
    func configure(with item: Item) {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .systemBackground
        backgroundConfiguration = backgroundConfig
        
        var config = defaultContentConfiguration()
        config.text = item.text
        config.secondaryText = item.secondaryText
        
        config.textProperties.font = .preferredFont(forTextStyle: .title3).bold()
        config.textProperties.color = .white
        config.textProperties.alignment = .center
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .caption1)
        config.secondaryTextProperties.alignment = .center
        config.secondaryTextProperties.color = .white
        
        contentConfiguration = config
    }
    
    func configure(withItem item: Item, andBackgroundView backgroundView: UIView) {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.customView = backgroundView
        backgroundConfiguration = backgroundConfig
        
        var config = defaultContentConfiguration()
        config.text = item.text
        config.secondaryText = item.secondaryText
        
        config.textProperties.font = .preferredFont(forTextStyle: .title1).bold()
        config.textProperties.color = .black
        config.textProperties.alignment = .center
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .caption1)
        config.secondaryTextProperties.alignment = .center
        config.secondaryTextProperties.color = .black
        
        contentConfiguration = config
    }
    
}
