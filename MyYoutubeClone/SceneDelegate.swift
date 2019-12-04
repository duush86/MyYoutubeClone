//
//  SceneDelegate.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 11/28/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        let layout = UICollectionViewFlowLayout()
        
        self.window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        UINavigationBar.appearance().barTintColor =  UIColor.rgb(red: 230, green: 32, blue: 31)
        
        
        //get ride of the weird line 
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        
        
        self.window?.makeKeyAndVisible()
        
        let statusBarBackgroundView = UIView()
        
        statusBarBackgroundView.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31)
        
        self.window?.addSubview(statusBarBackgroundView)
        
        self.window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        
        self.window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
        
    }

  


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

