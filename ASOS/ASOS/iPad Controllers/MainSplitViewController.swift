//
//  MainSplitViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class MainSplitViewController: UISplitViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    init() {
        super.init(style: .doubleColumn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let sidebar = Sidebar()
        let detailViewController = DetailViewController()
        let tabBarControllerForCompact = MainTabBarController()
        
        setViewController(sidebar, for: .primary)
        setViewController(detailViewController, for: .secondary)
        setViewController(tabBarControllerForCompact, for: .compact)
    }
    
}

