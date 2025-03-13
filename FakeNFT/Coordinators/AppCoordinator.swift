//
//  AppCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    /// Здесь можно внедрять зависимости (например, сервисы) через конструктор
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // Точка входа. Здесь выбираем нужный поток в зависимости от состояния пользователя.
    func start() {
        if UserManager.shared.isLoggedIn {
            showMainFlow()
        } else if !UserManager.shared.hasCompletedOnboarding {
            showOnboardingFlow()
        } else {
            showRegistrationFlow()
        }
    }

    func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.parentCoordinator = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    func showRegistrationFlow() {
        let registrationCoordinator = RegistrationCoordinator(navigationController: navigationController)
        registrationCoordinator.parentCoordinator = self
        childCoordinators.append(registrationCoordinator)
        registrationCoordinator.start()
    }

    func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }

    // Метод для удаления завершённого дочернего координатора
    func childDidFinish(_ child: Coordinator?) {
        if let child = child {
            childCoordinators.removeAll { $0 === child }
        }
    }
}



// MARK: - Пример ViewController для онбординга
class OnboardingViewController: UIViewController {
    weak var coordinator: OnboardingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        // Пример кнопки для завершения онбординга
        let finishButton = UIButton(type: .system)
        finishButton.setTitle("Завершить онбординг", for: .normal)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        finishButton.frame = CGRect(x: 50, y: 200, width: 220, height: 50)
        view.addSubview(finishButton)
    }

    @objc func finishTapped() {
        coordinator?.didFinishOnboarding()
    }
}

// MARK: - Пример менеджера состояния пользователя
class UserManager {
    static let shared = UserManager()

    var isLoggedIn: Bool = false
    var hasCompletedOnboarding: Bool = false

    private init() {}
}

// MARK: - Дополнительные координаторы (пример для регистрации и основного потока)

// Координатор регистрации
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

class RegistrationViewController: UIViewController {
    weak var coordinator: RegistrationCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupUI()
    }

    func setupUI() {
        let finishButton = UIButton(type: .system)
        finishButton.setTitle("Завершить регистрацию", for: .normal)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        finishButton.frame = CGRect(x: 50, y: 200, width: 220, height: 50)
        view.addSubview(finishButton)
    }

    @objc func finishTapped() {
        coordinator?.didFinishRegistration()
    }
}
