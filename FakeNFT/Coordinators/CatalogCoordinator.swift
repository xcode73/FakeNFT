//
//  CatalogCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 19.03.2025.
//

import UIKit

final class CatalogCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        print("CatalogCoordinator deinit")
    }

    func start() {
        let viewModel = CollectionsViewModel()
        let viewController = CollectionsViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(
            title: L10n.Tab.catalog,
            image: .catalogTab,
            selectedImage: nil
        )
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension CatalogCoordinator: CollectionsViewControllerDelegate {
    func didRequestDetail(for collection: Collection) {
        let collectionViewModel = CollectionViewModel(collectionUI: collection)
        let collectionViewController = CollectionViewController(viewModel: collectionViewModel)
        collectionViewController.delegate = self
        collectionViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(collectionViewController, animated: true)
    }
}

extension CatalogCoordinator: CollectionViewControllerDelegate {
    func didRequestWebView(_ url: URL) {
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewController(viewModel: webViewViewModel)
        webViewController.delegate = self
        navigationController.pushViewController(webViewController, animated: true)
    }
}

extension CatalogCoordinator: WebViewControllerDelegate {
    func didTapBackButton(_ controller: WebViewController) {
        navigationController.popViewController(animated: true)
    }
}
