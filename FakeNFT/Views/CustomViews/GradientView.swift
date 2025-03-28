//
//  GradientView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.03.2025.
//

import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.ypBlackUniversal.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}
