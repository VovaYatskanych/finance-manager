//
//  MainCoordinator.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController.instantiateStatsViewController(coordinator: self)
        navigationController.pushViewController(mainViewController, animated: false)
    }
}
