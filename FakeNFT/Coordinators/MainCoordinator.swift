//
//  MainCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var tabBarController: UITabBarController

    init() {
        self.navigationController = UINavigationController()
        self.tabBarController = TabBarController()
    }

    func start() {
        let profileNavController = CustomNavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator.start()

        let catalogNavController = CustomNavigationController()
        let catalogCoordinator = CatalogCoordinator(navigationController: catalogNavController)
        catalogCoordinator.start()

        let cartNavController = CustomNavigationController()
        let cartCoordinator = CartCoordinator(navigationController: cartNavController)
        cartCoordinator.start()

        let statisticsNavController = CustomNavigationController()
        let statisticsCoordinator = StatisticsCoordinator(navigationController: statisticsNavController)
        statisticsCoordinator.start()

        childCoordinators.append(profileCoordinator)
        childCoordinators.append(catalogCoordinator)
        childCoordinators.append(cartCoordinator)
        childCoordinators.append(statisticsCoordinator)

        tabBarController.viewControllers = [
            profileNavController,
            catalogNavController,
            cartNavController,
            statisticsNavController
        ]

        tabBarController.selectedIndex = 1
    }
}
