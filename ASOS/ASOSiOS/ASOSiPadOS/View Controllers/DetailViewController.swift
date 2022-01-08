//
//  DetailViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 06/01/2022.
//

import UIKit
import ASOS

final class DetailViewController: UIViewController {
    
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
        let sections: [Section] = [.announcements, .extraSales, .featuredAndGrid, .sales, .yourEdit, .recent]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach({snapshot.appendItems(Section.items(forSection: $0), toSection: $0)})
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - UICollectionView Helpers
extension DetailViewController {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let extraSalesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemGreen, leftColor: .systemTeal))
        }
        
        let featuredAndGridCellRegistration = UICollectionView.CellRegistration<ImageLabelsCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let salesCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(withItem: item, andBackgroundView: GradientBackgroundView(rightColor: .systemTeal, leftColor: .systemIndigo))
        }
        
        let yourEditCellRegistration = UICollectionView.CellRegistration<YourEditCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let recentlyViewedCellRegistration = UICollectionView.CellRegistration<RecentlyViewedCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let recentSectionHeaderRegistration = UICollectionView.SupplementaryRegistration<RecentlyViewedHeader>(elementKind: UICollectionView.elementKindSectionHeader) { (_, _, _) in }
        
        let dataSource =  UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
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
    
    private var sectionHorizontalEdgeSpacing: CGFloat { 50.0 }
    private var interItemOrGroupSpacing: CGFloat { 16.0 }
    
    private func makeLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = interItemOrGroupSpacing

        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionNumber) else { return nil }
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
        let sectionHeight: NSCollectionLayoutDimension = .fractionalHeight(3/5)
        
        let leadingItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        
        let topGridItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        topGridItem.contentInsets = .init(top: 0, leading: interItemOrGroupSpacing, bottom: 0, trailing: 0)
        let bottomGridItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        bottomGridItem.contentInsets = .init(top: 0, leading: interItemOrGroupSpacing, bottom: 0, trailing: 0)
        
        let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)), subitems: [topGridItem])
        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)), subitems: [bottomGridItem])
        bottomGroup.contentInsets = .init(top: interItemOrGroupSpacing, leading: 0, bottom: 0, trailing: 0)
        let gridGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)), subitems: [topGroup, bottomGroup])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: sectionHeight), subitems: [leadingItem, gridGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: sectionHorizontalEdgeSpacing, bottom: 0, trailing: sectionHorizontalEdgeSpacing)
        
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
