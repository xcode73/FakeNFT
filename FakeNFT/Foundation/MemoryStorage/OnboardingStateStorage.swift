//
//  OnboardingStateStorage.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import Foundation

protocol OnboardingStateStorage: AnyObject {
    var completed: Bool { get set }
}

class OnboardingStateStorageImpl: OnboardingStateStorage {
    @UserDefault(key: "isOnboardingCompleted", defaultValue: false)
    private var isOnboardingCompleted: Bool

    var completed: Bool {
        get {
            return isOnboardingCompleted
        }
        set {
            isOnboardingCompleted = newValue
        }
    }
}
