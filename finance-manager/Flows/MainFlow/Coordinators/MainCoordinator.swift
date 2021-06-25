//
//  MainCoordinator.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        let mainViewController = MainViewController.instantiateStatsViewController(coordinator: self)
        tabBarController.setViewControllers([mainViewController], animated: true)
    }
}
