//
//  RegistrationViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.03.2025.
//

import UIKit

class RegistrationViewController: UIViewController {
    weak var coordinator: RegistrationCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupUI()
    }

    func setupUI() {
        let finishButton = UIButton(type: .system)
        finishButton.setTitle("Завершить регистрацию", for: .normal)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        finishButton.frame = CGRect(x: 50, y: 200, width: 220, height: 50)
        view.addSubview(finishButton)
    }

    @objc func finishTapped() {
        coordinator?.didFinishRegistration()
    }
}
