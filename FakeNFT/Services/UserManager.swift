//
//  UserManager.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.03.2025.
//

import Foundation

protocol UserManager {
    var isLoggedIn: Bool { get set }
}

class UserManagerImpl: UserManager {
    var isLoggedIn: Bool = true
}
