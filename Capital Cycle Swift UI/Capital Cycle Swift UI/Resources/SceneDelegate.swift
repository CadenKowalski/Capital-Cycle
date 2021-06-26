//
//  SceneDelegate.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Create the SwiftUI view that provides the window contents.
        let loginPge = Login()
        
        let welcomePage = Welcome(progressBarValue: 0)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            
            /// Remove during final release
             UserDefaults.standard.setValue(false, forKey: "hasAlreadyLaunched")
             UserDefaults.standard.setValue(false, forKey: "userHasContinuedThroughWelcomePage")
            /// Remove during final release
            
            let window = UIWindow(windowScene: windowScene)
            if UserDefaults.standard.bool(forKey: "hasAlreadyLaunched") && UserDefaults.standard.bool(forKey: "userHasContinuedThroughWelcomePage") {
                
                window.rootViewController = UIHostingController(rootView: loginPge)
            } else {
                
                UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
                window.rootViewController = UIHostingController(rootView: welcomePage)
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
