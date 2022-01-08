//
//  SceneDelegate.swift
//  ASOS_App
//
//  Created by Suhayl Ahmed on 08/01/2022.
//

import UIKit
import ASOSiPadOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainViewController = MainSplitViewController()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()

    }
    
}
