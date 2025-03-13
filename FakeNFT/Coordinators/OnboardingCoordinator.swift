//
//  OnboardingCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
    }

    // Вызывается при завершении онбординга
    func didFinishOnboarding() {
        // Сообщаем родительскому координатору, что этот поток завершён
        parentCoordinator?.childDidFinish(self)
        // Переход к следующему потоку, например, регистрации
        parentCoordinator?.showRegistrationFlow()
    }
}
