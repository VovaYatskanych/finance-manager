//
//  AppCoordinator.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showMainViewController()
    }
        
    private func showMainViewController() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
