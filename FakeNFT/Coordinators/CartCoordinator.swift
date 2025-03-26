//
//  CartCoordinator.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 19.03.2025.
//

import UIKit

final class CartCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let cartViewModel = CartViewModel()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = CartViewController(viewModel: cartViewModel)
        viewController.tabBarItem = UITabBarItem(
            title: L10n.Tab.cart,
            image: .icCartFill,
            selectedImage: nil
        )
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension CartCoordinator: CartViewControllerDelegate {
    func didRequestPaymentDetail(cartViewModel: CartViewModelProtocol) {
        let viewModel = PaymentViewModel()
        let viewController = PaymentViewController(
            viewModel: viewModel,
            cartViewModel: cartViewModel
        )
        viewController.delegate = self
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func didRequestDeleteItem(nftId: String, image: UIImage) {

        let deleteViewModel = DeleteViewModel(image: image) { [weak self] in
            self?.cartViewModel.deleteItem(with: nftId)
        }

        let viewController = DeleteViewController(viewModel: deleteViewModel)
        viewController.delegate = self

        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true)
    }
}

extension CartCoordinator: PaymentViewControllerDelegate {
    func didRequestSuccess() {
        let viewController = SuccessViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }

    func didRequestWebView(_ url: URL) {
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewController(viewModel: webViewViewModel)
        webViewController.delegate = self
        navigationController.pushViewController(webViewController, animated: true)
    }
}

extension CartCoordinator: WebViewControllerDelegate {
    func didTapBackButton(_ controller: WebViewController) {
        navigationController.popViewController(animated: true)
    }
}

extension CartCoordinator: DeleteViewControllerDelegate {
    func didDismiss() {
        navigationController.dismiss(animated: true)
    }
}

extension CartCoordinator: SuccessViewControllerDelegate {
    func didRequestCatalog() {
        navigationController.dismiss(animated: true) { [weak self] in
            guard
                let self = self,
                let tabBarController = self.navigationController.tabBarController
            else {
                return
            }

            tabBarController.selectedIndex = 1
        }
    }
}
