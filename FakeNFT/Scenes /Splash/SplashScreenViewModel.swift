//
//  SplashScreenViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import Foundation

protocol SplashScreenViewModel {
    var isOnboardingCompleted: Bool { get }
    var servicesAssembly: ServicesAssembly { get }
    func completeOnboarding()
}

final class SplashScreenViewModelImpl: SplashScreenViewModel {
    var isOnboardingCompleted: Bool {
        return storage.completed
    }

    let servicesAssembly: ServicesAssembly

    private var storage: OnboardingStateStorage

    init(
        servicesAssembly: ServicesAssembly,
        onboardingStateStorage: OnboardingStateStorage
    ) {
        self.servicesAssembly = servicesAssembly
        self.storage = onboardingStateStorage
    }

    func completeOnboarding() {
        storage.completed = true
    }
}
