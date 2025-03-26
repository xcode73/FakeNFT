import UIKit

protocol LinePageControlDelegate: AnyObject {
    func linePageControl(_ pageControl: UIPageControl, didTapIndicatorAtIndex index: Int)
}

final class LinePageControl: UIPageControl {
    weak var delegate: LinePageControlDelegate?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()

        addSubview(stackView)
        stackView.constraintEdges(to: self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTapGesture()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    private func indicatorIndex(for tapPoint: CGPoint) -> Int? {
        let indicatorSize: CGFloat = 7.0
        let spacing: CGFloat = 10.0
        let totalWidth = CGFloat(numberOfPages) * indicatorSize + CGFloat(numberOfPages - 1) * spacing
        let startX = (bounds.size.width - totalWidth) / 2.0

        if tapPoint.x >= startX && tapPoint.x < startX + totalWidth {
            let relativeX = tapPoint.x - startX
            let indicatorIndex = Int(relativeX / (indicatorSize + spacing))
            return indicatorIndex
        }

        return nil
    }

    // MARK: - Actions
    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self)
        if let tappedIndicatorIndex = indicatorIndex(for: tapPoint) {
            currentPage = tappedIndicatorIndex
            delegate?.linePageControl(self, didTapIndicatorAtIndex: tappedIndicatorIndex)
        }
    }
}
