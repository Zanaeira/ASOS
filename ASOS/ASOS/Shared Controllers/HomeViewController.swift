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
    
    private func configureHierarchy() {
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func updateSnapshot() {
        let sections: [Section] = [.announcements, .sales, .featured, .grid, .special, .yourEdit, .recent]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach({snapshot.appendItems(Section.items(forSection: $0), toSection: $0)})
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionView Helpers
extension HomeViewController {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let itemCellRegistration = UICollectionView.CellRegistration<ItemCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            
            guard let section = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else { return }
            cell.styleForSection(section)
        }
        
        let imageTextCellRegistration = UICollectionView.CellRegistration<ImageTextCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let yourEditCellRegistration = UICollectionView.CellRegistration<YourEditCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let recentlyViewedCellRegistration = UICollectionView.CellRegistration<RecentlyViewedCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let recentSectionHeaderRegistration = UICollectionView.SupplementaryRegistration<RecentlyViewedHeader>(elementKind: UICollectionView.elementKindSectionHeader) { (_, _, _) in }
        
        let dataSource =  UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = self.dataSource.snapshot().sectionIdentifier(containingItem: itemIdentifier)
            if section == .special {
                return collectionView.dequeueConfiguredReusableCell(using: imageTextCellRegistration, for: indexPath, item: itemIdentifier)
            } else if section == .yourEdit {
                return collectionView.dequeueConfiguredReusableCell(using: yourEditCellRegistration, for: indexPath, item: itemIdentifier)
            } else if section == .recent {
                return collectionView.dequeueConfiguredReusableCell(using: recentlyViewedCellRegistration, for: indexPath, item: itemIdentifier)
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexPath, item: itemIdentifier)
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
            case .announcements: return self.announcementsSection(withTopSpacing: self.spacing)
            case .sales: return self.salesSection()
            case .featured: return self.featuredSection()
            case .grid: return self.gridSection()
            case .special: return self.specialSection()
            case .yourEdit: return self.yourEditSection()
            case .recent: return self.carouselSection()
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        layout.register(RecentlyViewedBackgroundDecorationView.self, forDecorationViewOfKind: RecentlyViewedBackgroundDecorationView.sectionBackgroundDecorationElementKind)
        
        return layout
    }

    private func announcementsSection(withTopSpacing topSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let itemHeight: NSCollectionLayoutDimension = .estimated(1)

        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: itemHeight), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: topSpacing, leading: spacing, bottom: 0, trailing: spacing)
        section.interGroupSpacing = spacing
        
        return section
    }
    
    private func salesSection() -> NSCollectionLayoutSection {
        return announcementsSection()
    }
    
    private func featuredSection() -> NSCollectionLayoutSection {
        return announcementsSection()
    }
    
    private func gridSection() -> NSCollectionLayoutSection {
        let itemHeight: NSCollectionLayoutDimension = .estimated(1)
        
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
        return announcementsSection()
    }
    
    private func yourEditSection() -> NSCollectionLayoutSection {
        return announcementsSection()
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
