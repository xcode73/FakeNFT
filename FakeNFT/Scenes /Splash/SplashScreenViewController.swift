//
//  SplashScreenViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

class SplashScreenViewController: UIViewController {
    private let viewModel: SplashScreenViewModel

    private var isOnboardingCompleted = false

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .icLaunch
        view.tintColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(
        viewModel: SplashScreenViewModel
    ) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.isOnboardingCompleted {
            switchToTabBarController()
        } else {
            switchToOnboardingViewController()
        }
    }

    // MARK: - Navigation
    private func switchToOnboardingViewController() {
        let viewModel = OnboardingViewModelImpl()
        let viewController = OnboardingViewController(viewModel: viewModel)
        viewController.onboardingDelegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }

    private func switchToTabBarController() {
        let tabBarController = TabBarController(
            servicesAssembly: viewModel.servicesAssembly
        )

        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }

        window.rootViewController = tabBarController
    }

    // MARK: - Constraints
    private func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - OnboardingViewControllerDelegate
extension SplashScreenViewController: OnboardingViewControllerDelegate {
    func onboardingCompleted() {
        dismiss(animated: true)
    }
}
