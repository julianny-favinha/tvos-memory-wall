//
//  AppDelegate.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKSettings.setClientToken("b812384b6bedefde1b84fc6a191c2e9a")
        
        // Check the number of executions
        if UserDefaultsManager.getNumberOfExecutions() == 0 {
            // Load initial settings
            // Load local images dict
            let dict = [CategoryPhotos.abstract.rawValue: true,
                        CategoryPhotos.city.rawValue: false,
                        CategoryPhotos.gaming.rawValue: false,
                        CategoryPhotos.nature.rawValue: false]
            UserDefaultsManager.setSelectedLocalImagesDict(to: dict)
        }
        // ++
        UserDefaultsManager.updateNumberOfExecutions()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
}
