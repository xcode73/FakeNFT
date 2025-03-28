//
//  AppCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit
import Dependencies

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }

    func start()
}

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    @Dependency(\.onboardingStateStorage) var onboardingStateStorage
    @Dependency(\.userManager) var userManager

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showSplashScreen()
    }

    func childDidFinish(_ child: Coordinator?) {
        if let child = child {
            childCoordinators.removeAll { $0 === child }
        }
    }

    private func determineFlow() {
        if !onboardingStateStorage.completed {
            showOnboardingFlow()
        } else if userManager.isLoggedIn {
            showMainFlow()
        } else {
            showRegistrationFlow()
        }
    }

    private func showSplashScreen() {
        let splashVC = SplashScreenViewController()
        navigationController.viewControllers = [splashVC]

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Имитация загрузки
            self.determineFlow()
        }
    }

    private func showOnboardingFlow() {
        let onboardingPageVC = OnboardingPageViewController()
        onboardingPageVC.onboardingDelegate = self

        replaceRootViewController(with: onboardingPageVC)
    }

    private func showRegistrationFlow() {
        let registrationNavController = UINavigationController()
        let registrationCoordinator = RegistrationCoordinator(navigationController: registrationNavController)
        registrationCoordinator.parentCoordinator = self
        childCoordinators.append(registrationCoordinator)
        registrationCoordinator.start()
    }

    func showMainFlow() {
        let mainCoordinator = MainCoordinator()
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        replaceRootViewController(with: mainCoordinator.tabBarController)
    }

    private func replaceRootViewController(
        with newRootViewController: UIViewController,
        animated: Bool = true
    ) {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            return
        }

        window.rootViewController = newRootViewController
        if animated {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
    }
}

extension AppCoordinator: OnboardingPageViewControllerDelegate {
    func didFinishOnboarding() {
        onboardingStateStorage.completed = true
        determineFlow()
    }
}
