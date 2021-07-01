// 
//  AppDelegate.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var app: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        let appCoordinator = AppCoordinator(navigationController: navigationController, window: window)
        app = appCoordinator
        appCoordinator.start()
        
        return true
    }
}

