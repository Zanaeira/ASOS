//
//  MainSplitViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit
import ASOS
import ASOSiOS

public final class MainSplitViewController: UISplitViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let itemLoader: ItemLoader
    private let itemUpdater: ItemUpdater
    
    public init(itemLoader: ItemLoader, itemUpdater: ItemUpdater) {
        self.itemLoader = itemLoader
        self.itemUpdater = itemUpdater
        
        super.init(style: .doubleColumn)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let sidebar = Sidebar()
        let detailViewController = DetailViewController(itemLoader: itemLoader)
        detailViewController.itemLiked = updateItemLiked
        let tabBarControllerForCompact = MainTabBarController(itemLoader: itemLoader)
        tabBarControllerForCompact.itemLiked = updateItemLiked
        
        setViewController(sidebar, for: .primary)
        setViewController(detailViewController, for: .secondary)
        setViewController(tabBarControllerForCompact, for: .compact)
    }
    
    private func updateItemLiked(itemId: String, liked: Bool) {
        itemUpdater.update(itemId: itemId, updateData: .init(itemLiked: liked))
    }
    
}

