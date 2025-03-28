//
//  StatisticsCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 19.03.2025.
//

import UIKit

final class StatisticsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = StatisticsViewModel()
        let viewController = StatisticsViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(title: L10n.Tab.statistic,
                                                 image: .icStatisticsFill,
                                                 selectedImage: nil)
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: - StatisticsViewControllerDelegate
extension StatisticsCoordinator: StatisticsViewControllerDelegate {
    func didRequestDetail(for user: User) {
        let userCardViewModel = UserCardViewModel(userId: user.id)
        let userCardViewController = UserCardViewController(viewModel: userCardViewModel)
        userCardViewController.hidesBottomBarWhenPushed = true
        userCardViewController.delegate = self

        navigationController.pushViewController(userCardViewController, animated: true)
    }
}

extension StatisticsCoordinator: UserCardViewControllerDelegate {
    func didRequestCollection(userId: String, nftIds: [String]) {
        let viewModel = UserNftCollectionViewModel(userId: userId, nftIds: nftIds)
        let viewController = UserNftCollectionViewController(viewModel: viewModel)

        navigationController.pushViewController(viewController, animated: true)
    }

    func didRequestWebView(_ url: URL) {
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewController(viewModel: webViewViewModel)
        webViewController.delegate = self
        navigationController.pushViewController(webViewController, animated: true)
    }
}

extension StatisticsCoordinator: WebViewControllerDelegate {
    func didTapBackButton(_ controller: WebViewController) {
        navigationController.popViewController(animated: true)
    }
}
