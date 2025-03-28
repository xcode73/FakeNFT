import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarAppearance()
    }

    // MARK: - Appearance
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhite

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlack,
            .font: UIFont.caption4
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlueUniversal,
            .font: UIFont.caption4
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlueUniversal
        appearance.stackedLayoutAppearance.normal.iconColor = .ypBlack
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.shadowImage = nil
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
