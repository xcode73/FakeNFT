//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingCompleted()
}

class OnboardingViewController: UIPageViewController {
    weak var onboardingDelegate: OnboardingViewControllerDelegate?
    private let viewModel: OnboardingViewModel
    private var currentIndex = 0

    // MARK: - UI Components
    private lazy var pageControl: LinePageControl = {
        let view = LinePageControl()
        view.numberOfPages = viewModel
        view.currentPage = currentIndex
        view.currentPageIndicatorTintColor = .ypBlack
        view.pageIndicatorTintColor = .ypWhite
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(
        viewModel: OnboardingViewModel
    ) {
        self.viewModel = viewModel

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

        setupLayout()
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

    private func setupLayout() {
        view.addSubview(pageControl)

        setViewControllers(currentIndex, direction: .forward)
        addPageControl()
    }

    // MARK: - Constraints
    private func addPageControl() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -175)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
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
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let onboardingVCs = pageViewController.viewControllers as? [OnboardingContentViewController],
            let currentIndex = onboardingItems.firstIndex(of: onboardingVCs[0].onboardingItem)
        else { return }

        self.currentIndex = currentIndex
        pageControl.currentPage = currentIndex
    }
}

// MARK: - CustomPageControlDelegate
extension OnboardingViewController: CustomPageControlDelegate {
    func customPageControl(_ pageControl: UIPageControl,
                           didTapIndicatorAtIndex index: Int
    ) {
        var direction: UIPageViewController.NavigationDirection = .forward

        if index < currentIndex {
            direction = .reverse
        }

        setViewControllers(index, direction: direction)
        currentIndex = index
    }
}

// MARK: - OnboardingContentViewControllerDelegate
extension OnboardingViewController: OnboardingContentViewControllerDelegate {
    func didTapConfirmButton() {
        UserDefaults.standard.isOnboardingCompleted = true
        setupStatisticStore()
        onboardingDelegate?.onboardingCompleted()
    }
}
