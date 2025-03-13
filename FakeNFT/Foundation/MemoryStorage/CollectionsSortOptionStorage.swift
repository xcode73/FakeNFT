//
//  CollectionsSortOptionStorage.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 03.03.2025.
//

import Foundation

protocol CollectionsSortOptionStorage {
    func saveSortOption(_ option: CollectionSortOptions)
    func loadSortOption() -> CollectionSortOptions
}

final class CollectionsSortOptionStorageImpl: CollectionsSortOptionStorage {
    @UserDefault(
        key: "CollectionSortOption",
        defaultValue: CollectionSortOptions.none.rawValue,
        userDefaults: UserDefaults.standard
    )
    private var storedSortOption: String

    func saveSortOption(_ option: CollectionSortOptions) {
        storedSortOption = option.rawValue
    }

    func loadSortOption() -> CollectionSortOptions {
        guard let sortOption = CollectionSortOptions(rawValue: storedSortOption) else {
            return .none
        }
        return sortOption
    }
}
