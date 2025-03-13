//
//  MainCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

class MainCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = TabBarController(servicesAssembly: <#ServicesAssembly#>)
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
