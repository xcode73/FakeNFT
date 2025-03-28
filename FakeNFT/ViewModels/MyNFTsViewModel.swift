import Foundation
import Dependencies

// MARK: - Protocol
protocol MyNFTsViewModel {
    var nfts: Observable<[Nft]> { get }
    var isRefreshing: Observable<Bool> { get }
    var isLoading: Bool { get }
    var errorModel: Observable<ErrorModel?> { get }

    func isLikedNft(at indexPath: IndexPath) -> Bool
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath)
    func refreshNfts()
    func sortNfts(by option: SortOption)
}

// MARK: - Implementation
final class MyNFTsViewModelImpl: MyNFTsViewModel {
    // MARK: - Properties
    @Dependency(\.nftService) var nftService
    @Dependency(\.profileService) var profileService

    let nfts = Observable<[Nft]>(value: [])
    let isRefreshing = Observable<Bool>(value: false)
    var errorModel = Observable<ErrorModel?>(value: nil)
    var isLoading = true

    private var sortOption = SortOption.name
    private var favourites: Set<String>

    // MARK: - Init
    init(
        nftIds: [NftID],
        favourites: [String]
    ) {
        self.favourites = Set(favourites)
        fetchNfts(ids: nftIds)
    }

    func isLikedNft(at indexPath: IndexPath) -> Bool {
        guard indexPath.item < nfts.value.count else { return false }
        return favourites.contains(nfts.value[indexPath.item].id)
    }

    func didTapFavouriteButtonOnCell(at indexPath: IndexPath) {
        guard indexPath.item < nfts.value.count else { return }
        let nftId = nfts.value[indexPath.item].id

        if favourites.contains(nftId) {
            favourites.remove(nftId)
        } else {
            favourites.insert(nftId)
        }

        profileService.updateFavouritesNft(favourites: Array(favourites)) { [weak self] result in
            guard let self = self else { return }
            if case .success(let profile) = result {
                self.favourites = Set(profile.likes)
            }
        }
    }

    func refreshNfts() {
        isRefreshing.value = true
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.nfts.value = []
                self.favourites = Set(profile.likes)
                self.fetchNfts(ids: profile.nfts)
            case .failure(let error):
                errorModel.value = createErrorModel(with: error)
            }

            self.isRefreshing.value = false
        }
    }

    func sortNfts(by option: SortOption) {
        sortOption = option
        nfts.value = nfts.value.sorted(by: option)
    }

    // MARK: - Private Methods

    private func fetchNfts(ids: [NftID]) {
        nftService.loadNfts(ids: ids) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                isLoading = false
                let sortedNfts = nfts.sorted(by: sortOption)
                self.nfts.value = sortedNfts
            case .failure(let error):
                errorModel.value = createErrorModel(with: error)
            }
        }
    }

    private func createErrorModel(with error: Error) -> ErrorModel {
        switch error {
        case ProfileServiceError.profileFetchingFail:
            return ErrorModel(
                message: L10n.Error.update,
                actionText: L10n.Button.close,
                action: { }
            )
        case is NetworkClientError:
            return ErrorModel(
                message: L10n.Error.network,
                actionText: L10n.Button.close,
                action: { }
            )
        default:
            return ErrorModel(
                message: L10n.Profile.unknownError,
                actionText: L10n.Button.close,
                action: { }
            )
        }
    }
}

// MARK: - Sort

private extension Array where Element == Nft {
    func sorted(by option: SortOption) -> Self {
        var sortedArray: Self = []
        switch option {
        case .name:
            sortedArray = self.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .price:
            sortedArray = self.sorted { $0.price > $1.price }
        case .rating:
            sortedArray = self.sorted { $0.rating > $1.rating }
        default:
            break
        }
        return sortedArray
    }
}
