// 
//  AppLifecycle.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

protocol AppLifecycle {
        var isEnabled: Bool { get }
    func onDidLaunch(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    
}

extension AppLifecycle {
    var isEnabled: Bool {
        return true
    }
}
