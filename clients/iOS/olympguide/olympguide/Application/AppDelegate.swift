//
//  AppDelegate.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let customFont = UIFont(name: "MontserratAlternates-Medium", size: 20) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .foregroundColor: UIColor.black  // или другой цвет по желанию
            ]
            UINavigationBar.appearance().titleTextAttributes = attributes
        }
        
        if let customFont = UIFont(name: "MontserratAlternates-Bold", size: 28) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .foregroundColor: UIColor.black
            ]
            UINavigationBar.appearance().largeTitleTextAttributes = attributes
        }
        
        if let customFont = UIFont(name: "MontserratAlternates-Medium", size: 17) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .foregroundColor: UIColor.systemBlue // или другой цвет
            ]
            UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait // Используйте .landscape или другие варианты, если нужно
    }
}

