//
//  MainTabBarController.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        viewControllers = [
            makeShoppingViewController(), makeSearchViewController(), makeBagViewController(), makeSavedItemsViewController(), makeProfileViewController()
        ]
    }
    
    private func makeShoppingViewController() -> UINavigationController {
        let viewController = HomeViewController()
        viewController.tabBarItem.image = UIImage(systemName: "a.circle.fill")
        
        return UINavigationController(rootViewController: viewController)
    }
    
    private func makeSearchViewController() -> UINavigationController {
        let viewController = makeSampleViewController()
        viewController.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")
        
        return viewController
    }
    
    private func makeBagViewController() -> UINavigationController {
        let viewController = makeSampleViewController()
        viewController.tabBarItem.image = UIImage(systemName: "bag.circle.fill")
        viewController.navigationBar.topItem?.title = "BAG"
        
        return viewController
    }
    
    private func makeSavedItemsViewController() -> UINavigationController {
        let viewController = makeSampleViewController()
        viewController.tabBarItem.image = UIImage(systemName: "heart.circle.fill")
        viewController.navigationBar.topItem?.title = "SAVED ITEMS"
        
        return viewController
    }
    
    private func makeProfileViewController() -> UINavigationController {
        let viewController = makeSampleViewController()
        viewController.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")
        viewController.navigationBar.topItem?.title = "MY ACCOUNT"
        
        return viewController
    }
    
    private func makeSampleViewController() -> UINavigationController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        
        return UINavigationController(rootViewController: viewController)
    }
    
}

