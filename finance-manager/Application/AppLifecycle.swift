// 
//  AppLifecycle.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

/**
 *  Objects conforming to this protocol provide some sort of configurable behavior intended for execution
 *  on app launch.
 */
protocol AppLifecycle {
    
    /// A check to see if the configuration is enabled.
    var isEnabled: Bool { get }
    
    /**
     Invoked on UIApplication.applicationDidFinishLaunching to give the conforming instance a chance to execute configuration.
     
     - parameter application:   The application
     - parameter launchOptions: Optional launch options
     */
    func onDidLaunch(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    
}

extension AppLifecycle {
    
    var isEnabled: Bool {
        return true
    }
    
}
