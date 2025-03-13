//
//  UserDefault.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    private let key: String
    private let defaultValue: Value
    private let userDefaults: UserDefaults

    init(
        key: String,
        defaultValue: Value,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: Value {
        get {
            guard let value = userDefaults.object(forKey: key) as? Value else {
                return defaultValue
            }
            return value
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
