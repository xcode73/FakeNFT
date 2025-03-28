import Foundation
import Dependencies

protocol ProfileViewModel {
    var profile: Observable<ProfileDTO?> { get }
    var isLoading: Observable<Bool> { get }
    var errorModel: Observable<ErrorModel?> { get }

    func viewWillAppear()
}

final class ProfileViewModelImpl: ProfileViewModel {
    var profile = Observable<ProfileDTO?>(value: nil)
    var isLoading = Observable<Bool>(value: true)
    var errorModel = Observable<ErrorModel?>(value: nil)

    @Dependency(\.profileService) var profileService

    func viewWillAppear() {
        fetchProfile()
    }

    private func createErrorModel(with error: Error) -> ErrorModel {
        switch error {
        case ProfileServiceError.profileFetchingFail:
            return ErrorModel(
                message: L10n.Profile.fetchingError,
                actionText: L10n.Error.repeat,
                action: { [weak self] in self?.fetchProfile() }
            )
        case ProfileServiceError.profileUpdatingFail:
            return ErrorModel(
                message: L10n.Profile.updatingError,
                actionText: L10n.Button.close,
                action: { [weak self] in self?.fetchProfile() }
            )
        default:
            return ErrorModel(
                message: L10n.Profile.unknownError,
                actionText: L10n.Button.close,
                action: { [weak self] in self?.fetchProfile() }
            )
        }
    }

    private func fetchProfile() {
        isLoading.value = true
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.isLoading.value = false
                self?.profile.value = profile
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }
}

extension ProfileViewModelImpl: ProfileEditingDelegate {
    func didEndEditingProfile(_ profileEditingDto: ProfileEditingDto) {
        isLoading.value = true
        profileService.updateProfile(with: profileEditingDto) { [weak self] result in
            switch result {
            case .success:
                self?.fetchProfile()
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }
}
