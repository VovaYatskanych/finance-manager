//
//  AppCoordinator.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

private extension String {
    static let mainItemTitle = "Main"
}

final class AppCoordinator: Coordinator {
    
    private let tabBarController: UITabBarController
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []
    
    init(tabBarController: UITabBarController, window: UIWindow) {
        self.tabBarController = tabBarController
        self.window = window
    }
    
    func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        showMainViewController()
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        tabBarController.tabBar.items?[0].title = .mainItemTitle
    }
    
    private func showMainViewController() {
        let mainCoordinator = MainCoordinator(tabBarController: tabBarController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
