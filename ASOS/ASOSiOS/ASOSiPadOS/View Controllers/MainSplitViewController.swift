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
    
    public init(itemLoader: ItemLoader) {
        self.itemLoader = itemLoader
        
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
        let tabBarControllerForCompact = MainTabBarController(itemLoader: itemLoader)
        
        setViewController(sidebar, for: .primary)
        setViewController(detailViewController, for: .secondary)
        setViewController(tabBarControllerForCompact, for: .compact)
    }
    
}

