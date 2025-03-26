//
//  RegistrationCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.03.2025.
//

import UIKit

class RegistrationCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let registrationVC = RegistrationViewController()
        registrationVC.coordinator = self
        navigationController.pushViewController(registrationVC, animated: true)
    }

    func didFinishRegistration() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.showMainFlow()
    }
}
