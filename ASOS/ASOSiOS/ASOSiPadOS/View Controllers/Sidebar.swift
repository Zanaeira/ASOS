//
//  Sidebar.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class Sidebar: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
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
    
    private let onSidebarItemSelected: ((String) -> Void)
    private var currentIndex: Int = -1

    init(onSidebarItemSelected: @escaping ((String) -> Void)) {
        self.onSidebarItemSelected = onSidebarItemSelected

        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureHierarchy()
        loadSidebarItems()
        collectionView.delegate = self
        setFirstItemInSidebar()
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
    
    private func setFirstItemInSidebar() {
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        self.collectionView(collectionView, didSelectItemAt: indexPath)
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

extension Sidebar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = dataSource.itemIdentifier(for: indexPath),
              currentIndex != indexPath.item else { return }
        
        currentIndex = indexPath.item
        onSidebarItemSelected(sidebarItem.title)
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
