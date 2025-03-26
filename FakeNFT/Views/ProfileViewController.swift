import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func profileViewControllerDidTapEditButton(profile: ProfileDTO)
    func profileViewControllerDidTapMyNfts(nfts: [String], favorites: [String])
    func profileViewControllerDidTapFavorites(likes: [String])
    func profileViewControllerDidTapDeveloper(url: URL)
    func profileViewControllerDidTapLink(url: URL)
}

final class ProfileViewController: UIViewController, ErrorView {
    // MARK: - Properties
    weak var delegate: ProfileViewControllerDelegate?

    private let viewModel: ProfileViewModel

    private enum ProfileRoutingTableViewSection: Hashable {
        case main
    }

    private enum ProfileRoutingTableViewItem: Hashable {
        case myNft(Int)
        case favorites(Int)
        case about

        var title: String {
            switch self {
            case .myNft(let num):
                return "\(L10n.Profile.myNftsRoute) (\(num))"
            case .favorites(let num):
                return "\(L10n.Profile.favouritesNftsRoute) (\(num))"
            case .about:
                return "\(L10n.Profile.aboutRoute)"
            }
        }
    }

    private
    typealias DataSource = UITableViewDiffableDataSource<ProfileRoutingTableViewSection, ProfileRoutingTableViewItem>

    private
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProfileRoutingTableViewSection, ProfileRoutingTableViewItem>

    private enum Constants {
        static let profileRoutingCellHeight = 70.0
        static let numberOfCells = 3
        static let activityIndicatorViewSize = CGSize(width: 25.0, height: 25.0)
    }

    // MARK: - UI
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .icEdit,
            style: .done,
            target: self,
            action: #selector(editButtonDidTap)
        )
        button.tintColor = .ypBlack
        return button
    }()

    private lazy var profileCardView: ProfileCardView = {
        let profileCardView = ProfileCardView()
        profileCardView.translatesAutoresizingMaskIntoConstraints = false
        return profileCardView
    }()

    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .caption1
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.addTarget(self, action: #selector(linkButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var profileRoutingTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var dataSource: DataSource = {
        DataSource(tableView: profileRoutingTableView) { _, _, routeItem in
            let cell = UITableViewCell()

            if #available(iOS 14.0, *) {
                var content = UIListContentConfiguration.cell()
                content.text = routeItem.title
                content.textProperties.font = .bodyBold
                content.textProperties.color = .ypBlack
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = routeItem.title
                cell.textLabel?.font = .bodyBold
                cell.textLabel?.textColor = .ypBlack
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .ypWhite
            cell.setAccessoryView(with: .ypBlack)
            return cell
        }
    }()

    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDataBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
        viewModel.viewWillAppear()
    }

    private func setupDataBindings() {
        viewModel.profile.bind { [weak self] profile in
            guard let profile else { return }
            self?.profileCardView.setAvatarImage(url: profile.avatar)
            self?.profileCardView.setNameText(profile.name)
            self?.profileCardView.setDescriptionText(profile.description)
            self?.linkButton.setTitle(profile.website, for: .normal)
            self?.applySnapshot(myNftsNumber: profile.nfts.count,
                                favouritesNumber: profile.likes.count)
        }

        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.startLoading()
            } else {
                self?.stopLoading()
            }
        }

        viewModel.errorModel.bind { [weak self] errorModel in
            guard let errorModel else { return }
            self?.showError(errorModel)
        }
    }

    private func startLoading() {
        navigationItem.rightBarButtonItem = nil
        profileCardView.isHidden = true
        linkButton.isHidden = true
        profileRoutingTableView.isHidden = true
        activityIndicatorView.startAnimating()
    }

    private func stopLoading() {
        navigationItem.rightBarButtonItem = editBarButtonItem
        activityIndicatorView.stopAnimating()
        profileCardView.isHidden = false
        linkButton.isHidden = false
        profileRoutingTableView.isHidden = false
    }

    private func applySnapshot(myNftsNumber: Int, favouritesNumber: Int) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.myNft(myNftsNumber), .favorites(favouritesNumber), .about])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Actions
    @objc private func editButtonDidTap() {
        guard let profile = viewModel.profile.value else { return }

        delegate?.profileViewControllerDidTapEditButton(profile: profile)
    }

    @objc private func linkButtonDidTap() {
        guard
            let website = viewModel.profile.value?.website,
            let url = URL(string: website)
        else {
            return
        }

        delegate?.profileViewControllerDidTapLink(url: url)
    }

    // MARK: - Layout
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews([activityIndicatorView, profileCardView, linkButton, profileRoutingTableView])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            linkButton.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: 8),
            linkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            profileRoutingTableView.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 40),
            profileRoutingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileRoutingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileRoutingTableView.heightAnchor.constraint(
                equalToConstant: Constants.profileRoutingCellHeight * CGFloat(Constants.numberOfCells)
            ),

            activityIndicatorView.heightAnchor.constraint(equalToConstant: Constants.activityIndicatorViewSize.height),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: Constants.activityIndicatorViewSize.width),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.profileRoutingCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let routingItem = dataSource.itemIdentifier(for: indexPath),
            let profile = viewModel.profile.value
        else {
            return
        }

        switch routingItem {
        case .myNft:
            delegate?.profileViewControllerDidTapMyNfts(
                    nfts: profile.nfts,
                    favorites: profile.likes
                )
        case .favorites:
            delegate?.profileViewControllerDidTapFavorites(likes: profile.likes)
        case .about:
            delegate?.profileViewControllerDidTapDeveloper(url: DeveloperConstants.url)
        }
    }
}
