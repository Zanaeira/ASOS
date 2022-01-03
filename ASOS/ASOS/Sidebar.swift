//
//  Sidebar.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class Sidebar: UIViewController {
    
    private enum Section { case main }
    fileprivate struct Item: Hashable {
        let image: UIImage?
        let title: String
        static let items: [Item] = [
            .init(image: UIImage(systemName: "a.circle.fill"), title: "ASOS"),
            .init(image: UIImage(systemName: "magnifyingglass.circle.fill"), title: "Search"),
            .init(image: UIImage(systemName: "bag.circle.fill"), title: "Shopping Bag"),
            .init(image: UIImage(systemName: "heart.circle.fill"), title: "Saved Items"),
            .init(image: UIImage(systemName: "person.crop.circle.fill"), title: "My Account")
        ]
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeSidebarLayout())
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureHierarchy()
        loadSidebarItems()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureHierarchy() {
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
    }
    
    private func loadSidebarItems() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Item.items, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private static func makeSidebarLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
    
}

private extension UICollectionViewListCell {
    
    func configure(with item: Sidebar.Item) {
        var content = defaultContentConfiguration()
        content.text = item.title
        content.image = item.image
        
        contentConfiguration = content
    }
    
}
