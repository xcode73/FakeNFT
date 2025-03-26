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

    // MARK: - UI
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = onboardingItem.image
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var gradientView: GradientView = {
        let view = GradientView()
        return view
    }()

    private lazy var vStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .headline6
        view.textColor = .ypWhiteUniversal
        view.text = onboardingItem.title
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .caption1
        view.numberOfLines = 0
        view.textColor = .ypWhiteUniversal
        view.text = onboardingItem.description
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var confirmButton: UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .ypBlackUniversal
        view.titleLabel?.font = .bodyBold
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        view.setTitle(onboardingItem.buttonTitle, for: .normal)
        if onboardingItem.buttonTitle == nil {
            view.isHidden = true
        }
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

    @objc
    private func didTapSkipButton() {
        delegate?.didTapConfirmButton()
    }

    // MARK: - Constraints
    private func setupLayout() {
        view.addSubview(backgroundImageView)
        view.addSubview(gradientView)
        view.addSubview(vStackView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(descriptionLabel)
        view.addSubview(confirmButton)

        backgroundImageView.constraintEdges(to: view)
        gradientView.constraintEdges(to: view)
        setupVStackViewConstraints()
        setupConfirmButtonConstraints()
    }

    private func setupVStackViewConstraints() {
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupConfirmButtonConstraints() {
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 686)
        ])
    }
}
