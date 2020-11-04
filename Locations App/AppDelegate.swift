//
//  AppDelegate.swift
//  Locations App
//
//  Created by Tabita Marusca on 26/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var router: Router?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        guard let window = window else { return false }
        router = Router(window: window)
        router?.startFlow()
        
        return true
    }
}

