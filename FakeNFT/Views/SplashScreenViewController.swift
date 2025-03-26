//
//  SplashScreenViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

class SplashScreenViewController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .icLaunch
        view.tintColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Constraints
    private func setupViews() {
        view.backgroundColor = .cyan
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
