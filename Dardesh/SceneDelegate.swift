//
//  SceneDelegate.swift
//  Dardesh
//
//  Created by Abdelnasser on 28/09/2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener:AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        autoLogin()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        LocationManager.shared.startUpdating()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
        LocationManager.shared.stopUpdating()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationManager.shared.stopUpdating()
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


    func autoLogin(){
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil && userDefult.object(forKey: kCURRENTUSER) != nil{
                DispatchQueue.main.async {
                    self.goToApp()
                }
            }
        })
    }
    
    private func goToApp(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar")as! UITabBarController
 
        self.window?.rootViewController = vc
    
    }
    
}

