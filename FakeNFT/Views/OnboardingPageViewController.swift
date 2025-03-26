//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

protocol OnboardingPageViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingPageViewController: UIPageViewController {
    weak var onboardingDelegate: OnboardingPageViewControllerDelegate?

    private let onboardingItems = Onboarding.items

    private var currentIndex = 0 {
        didSet {
            skipButton.isHidden = currentIndex == onboardingItems.count - 1
        }
    }

    // MARK: - UI
    private lazy var pageControl: ProgressPageControl = {
        let view = ProgressPageControl()
        view.numberOfPages = onboardingItems.count
        view.currentPage = currentIndex
        view.indicatorHeight = 4
        view.trackTintColor = .ypLightGrey
        view.progressTintColor = .ypBlack
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var skipButton: UIButton = {
        let view = UIButton()
        view.setImage(.icClose, for: .normal)
        view.tintColor = .ypWhite

        view.addTarget(self, action: #selector(skipToLastPage), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init() {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        setViewControllers(currentIndex, direction: .forward)
        setupLayout()

        pageControl.startProgress()
    }

    private func contentViewController(at index: Int) -> OnboardingContentViewController? {
        let viewController = OnboardingContentViewController(onboardingItem: onboardingItems[index])
        viewController.delegate = self

        return viewController
    }

    private func setViewControllers(_ index: Int, direction: UIPageViewController.NavigationDirection) {
        guard let contentViewController = contentViewController(at: index) else { return }

        setViewControllers(
            [contentViewController],
            direction: direction,
            animated: true,
            completion: nil
        )
    }

    @objc
    private func skipToLastPage() {
        let lastIndex = onboardingItems.count - 1
        guard let lastViewController = contentViewController(at: lastIndex) else { return }

        setViewControllers([lastViewController], direction: .forward, animated: true) { _ in
            self.currentIndex = lastIndex
            self.pageControl.currentPage = lastIndex
        }
    }

    private func setupLayout() {
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        setupPageControlConstraints()
        setupSkipButtonConstraints()
    }

    // MARK: - Constraints
    private func setupPageControlConstraints() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 28),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupSkipButtonConstraints() {
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 42),
            skipButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return contentViewController(at: onboardingItems.count - 1)
        }

        return contentViewController(at: previousIndex)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let nextIndex = currentIndex + 1
        guard nextIndex < onboardingItems.count else {
            return contentViewController(at: 0)
        }

        return contentViewController(at: nextIndex)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            completed,
            let viewController = pageViewController.viewControllers?.first as? OnboardingContentViewController,
            let index = onboardingItems.firstIndex(of: viewController.onboardingItem)
        else {
            return
        }

        currentIndex = index
        pageControl.currentPage = index
    }
}

// MARK: - ProgressPageControlDelegate
extension OnboardingPageViewController: ProgressPageControlDelegate {
    func progressPageControlDidFinishProgress(_ pageControl: ProgressPageControl) {
        let nextIndex = currentIndex + 1
        guard nextIndex < onboardingItems.count else { return }

        setViewControllers(nextIndex, direction: .forward)
        currentIndex = nextIndex
        pageControl.currentPage = nextIndex
    }

    func progressPageControl(_ pageControl: ProgressPageControl, didTapIndicatorAtIndex index: Int) {
        var direction: UIPageViewController.NavigationDirection = .forward

        if index < currentIndex {
            direction = .reverse
        }

        setViewControllers(index, direction: direction)
        currentIndex = index

        pageControl.startProgress()
    }
}

// MARK: - OnboardingContentViewControllerDelegate
extension OnboardingPageViewController: OnboardingContentViewControllerDelegate {
    func didTapConfirmButton() {
        onboardingDelegate?.didFinishOnboarding()
    }
}
