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
        
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .oneBesideSecondary
        
        let sidebar = Sidebar(onSidebarItemSelected: setDetailViewController)
        let tabBarControllerForCompact = MainTabBarController(itemLoader: itemLoader, itemUpdater: itemUpdater)
        
        setViewController(sidebar, for: .primary)
        setViewController(tabBarControllerForCompact, for: .compact)
    }
    
    private func setDetailViewController(title: String) {
        let vc: UIViewController
        if title == "ASOS" {
            vc = DetailViewController(itemLoader: itemLoader, itemUpdater: itemUpdater)
        } else {
            vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            vc.title = title.uppercased()
        }
        
        vc.navigationItem.hidesBackButton = true
        showDetailViewController(vc, sender: self)
    }
    
}
