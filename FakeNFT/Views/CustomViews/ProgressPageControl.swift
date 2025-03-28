//
//  ProgressPageControl.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.03.2025.
//

import UIKit

protocol ProgressPageControlDelegate: AnyObject {
    func progressPageControl(_ pageControl: ProgressPageControl, didTapIndicatorAtIndex index: Int)
    func progressPageControlDidFinishProgress(_ pageControl: ProgressPageControl)
}

final class ProgressPageControl: UIControl {
    weak var delegate: ProgressPageControlDelegate?

    var numberOfPages: Int = 0 {
        didSet { setupIndicators() }
    }

    var currentPage: Int = 0 {
        didSet { updateIndicators() }
    }

    var indicatorHeight: CGFloat = 4
    var trackTintColor: UIColor = .ypLightGrey
    var progressTintColor: UIColor = .ypBlack

    private let duration: TimeInterval = 5.0
    private var indicatorViews: [UIProgressView] = []
    private var timer: Timer?
    private var currentProgress: Float = 0.0

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.distribution = .fillEqually
        view.alignment = .center
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.constraintEdges(to: self)

        setupTapGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startProgress() {
        currentProgress = 0.0
        updateIndicators()
        timer?.invalidate()

        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(handleTimer),
            userInfo: nil,
            repeats: true
        )
    }

    private func indicatorIndex(for tapPoint: CGPoint) -> Int? {
        let spacingTotalSize = stackView.spacing * CGFloat(numberOfPages - 1)
        let availableWidth = bounds.size.width - spacingTotalSize
        let indicatorSize: CGFloat = availableWidth / CGFloat(numberOfPages)

        let spacing: CGFloat = stackView.spacing
        let totalWidth = CGFloat(numberOfPages) * indicatorSize + CGFloat(numberOfPages - 1) * spacing
        let startX = (bounds.size.width - totalWidth) / 2.0

        if tapPoint.x >= startX && tapPoint.x < startX + totalWidth {
            let relativeX = tapPoint.x - startX
            let indicatorIndex = Int(relativeX / (indicatorSize + spacing))
            return indicatorIndex
        }

        return nil
    }

    /// UIProgressView для каждого индикатора
    private func setupIndicators() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        indicatorViews = []
        for _ in 0..<numberOfPages {
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progress = 0.0
            progressView.trackTintColor = trackTintColor
            progressView.progressTintColor = progressTintColor
            progressView.heightAnchor.constraint(equalToConstant: indicatorHeight).isActive = true
            indicatorViews.append(progressView)
            stackView.addArrangedSubview(progressView)
        }
    }

    private func updateIndicators() {
        for (index, progressView) in indicatorViews.enumerated() {
            if index < currentPage {
                progressView.progress = 1.0
            } else if index == currentPage {
                progressView.progress = currentProgress
            } else {
                progressView.progress = 0.0
            }
        }
    }

    @objc
    private func handleTimer() {
        currentProgress += Float(0.1 / duration)
        if currentProgress >= 1.0 {
            currentProgress = 1.0
            timer?.invalidate()
            timer = nil
            updateIndicators()

            if currentPage < numberOfPages - 1 {
                currentPage += 1

                startProgress()
                sendActions(for: .valueChanged)
            }

            delegate?.progressPageControlDidFinishProgress(self)
        } else {
            updateIndicators()
        }
    }

    // MARK: - Обработка нажатий
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self)

        if let tappedIndicatorIndex = indicatorIndex(for: tapPoint) {
            currentPage = tappedIndicatorIndex
            delegate?.progressPageControl(self, didTapIndicatorAtIndex: tappedIndicatorIndex)
            startProgress()
            sendActions(for: .valueChanged)
        }
    }
}
