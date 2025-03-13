//
//  OnboardingContentViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

protocol OnboardingContentViewControllerDelegate: AnyObject {
    func didTapConfirmButton()
}

class OnboardingContentViewController: UIViewController {
    weak var delegate: OnboardingContentViewControllerDelegate?
    var onboardingItem: Onboarding

    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .bodyRegular
        view.textAlignment = .center
        view.numberOfLines = 3
        view.textColor = .black
        view.text = onboardingItem.description
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .bodyRegular
        view.textAlignment = .center
        view.numberOfLines = 3
        view.textColor = .black
        view.text = onboardingItem.description
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = onboardingItem.image
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var confirmButton: UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .black
        view.titleLabel?.font = .bodyBold
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        view.setTitle(onboardingItem.buttonTitle, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(onboardingItem: Onboarding) {
        self.onboardingItem = onboardingItem
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    // MARK: - Action
    @objc
    private func didTapConfirmButton() {
        delegate?.didTapConfirmButton()
    }

    // MARK: - Constraints
    private func setupLayout() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)

        setupBackgroundImageViewConstraints()
        setupFeatureLabelConstraints()
        setupDescriptionLabelConstraints()

        if let buttonTitle = onboardingItem.buttonTitle {
            view.addSubview(confirmButton)
            setupConfirmButtonConstraints()
        }
    }

    private func setupBackgroundImageViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupFeatureLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 478)
        ])
    }

    private func setupDescriptionLabelConstraints() {
        
    }

    private func setupConfirmButtonConstraints() {
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -93)
        ])
    }
}
