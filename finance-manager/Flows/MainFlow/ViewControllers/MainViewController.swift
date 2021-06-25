//
//  MainViewController.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

private extension String {
    static let mainStoryboardName = "Main"
    static let mainViewControllerId = "mainViewController"
}

final class MainViewController: UIViewController {
    weak var coordinator: MainCoordinator?
}

extension MainViewController {
    private static var mainStoryboard: UIStoryboard {
        UIStoryboard(name: .mainStoryboardName, bundle: .main)
    }
    
    static func instantiateStatsViewController(coordinator: MainCoordinator) -> MainViewController {
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: .mainViewControllerId) as! MainViewController
        mainViewController.coordinator = coordinator
        return mainViewController
    }
}
