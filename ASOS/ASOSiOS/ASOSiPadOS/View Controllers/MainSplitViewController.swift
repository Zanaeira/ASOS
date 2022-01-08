//
//  MainSplitViewController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit
import ASOSiOS

public final class MainSplitViewController: UISplitViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public init() {
        super.init(style: .doubleColumn)
    }
    
    public override func viewDidLoad() {
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

