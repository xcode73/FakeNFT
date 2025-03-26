import UIKit

final class ProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ProfileViewModelImpl()
        let viewController = ProfileViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(
            title: L10n.Tab.profile,
            image: .icTabProfile,
            selectedImage: nil
        )
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: - ProfileViewControllerDelegate
extension ProfileCoordinator: ProfileViewControllerDelegate {
    func profileViewControllerDidTapEditButton(profile: ProfileDTO) {
        guard
            let profileViewController = navigationController.topViewController as? ProfileViewController
        else {
            return
        }

        let viewModel = ProfileEditingViewModelImpl(profile: profile, coordinator: self)
        let profileEditingViewController = ProfileEditingViewController(viewModel: viewModel)
        profileViewController.present(profileEditingViewController, animated: true)
    }

    func profileViewControllerDidTapMyNfts(nfts: [String], favorites: [String]) {
        let viewModel = MyNFTsViewModelImpl(
            nftIds: nfts,
            favourites: favorites
        )

        let myNFTsViewController = MyNFTsViewController(viewModel: viewModel)
        navigationController.pushViewController(myNFTsViewController, animated: true)
    }

    func profileViewControllerDidTapFavorites(likes: [String]) {
        let viewModel = FavouritesNFTsViewModelImpl(favourites: likes)
        let viewController = FavouriteNFTsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func profileViewControllerDidTapDeveloper(url: URL) {
        let viewModel = WebViewViewModel(url: url)
        let webViewController = WebViewController(viewModel: viewModel)
        webViewController.delegate = self
        webViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewController, animated: true)
    }

    func profileViewControllerDidTapLink(url: URL) {
        let viewModel = WebViewViewModel(url: url)
        let webViewController = WebViewController(viewModel: viewModel)
        webViewController.delegate = self
        webViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewController, animated: true)
    }
}

// MARK: - WebViewControllerDelegate
extension ProfileCoordinator: WebViewControllerDelegate {
    func didTapBackButton(_ controller: WebViewController) {
        navigationController.popViewController(animated: true)
    }
}
