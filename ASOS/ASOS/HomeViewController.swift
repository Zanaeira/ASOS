//
//  HomeViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private enum Section: Int {
        case announcements
        case sales
        case featured
        
        static func items(forSection section: Section) -> [Item] {
            switch section {
            case .announcements: return [.init(text: "Premier Delivery\n\nUnlimited free Next-Day Delivery for a whole year for £9.95",
                                               secondaryText: "Ts&Cs apply")]
            case .sales: return [.init(text: "SALE:\nUP TO 80% OFF\nFINAL DISCOUNTS!",
                                               secondaryText: "Limited time only. While stocks lack. Selected styles marked down on site.")]
            case .featured: return [.init(text: "PITCH PERFECT", secondaryText: "Shop ASOS 4505", image: UIImage(named: "pitch-perfect"))]
            }
        }
    }
    
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
        let sections: [Section] = [.announcements, .sales, .featured]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach({snapshot.appendItems(Section.items(forSection: $0), toSection: $0)})
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - UICollectionView Helpers
extension HomeViewController {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<ItemCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
            
            guard let section = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else { return }
            switch section {
            case .announcements:
                cell.contentView.backgroundColor = .black
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.borderWidth = 1
                cell.configureFontColors(primaryTextColor: .white, secondaryTextColor: .white)
                cell.configureFonts(primaryTextFont: .preferredFont(forTextStyle: .body, weight: .bold), secondaryTextFont: .preferredFont(forTextStyle: .caption1))
            case .sales:
                cell.configureFonts(primaryTextFont: .preferredFont(forTextStyle: .title1, weight: .black), secondaryTextFont: .preferredFont(forTextStyle: .caption1))
                cell.configureFontColors(primaryTextColor: .black, secondaryTextColor: .black)
                cell.backgroundView = GradientBackgroundView(frame: .zero)
            case .featured: break
            }
        }
        
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
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
            }
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
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

}
