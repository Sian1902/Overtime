import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsCollection: UICollectionView!

    private var presenter: DetailsPresenterProtocol!

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .appPrimary
        ai.hidesWhenStopped = true
        return ai
    }()

    static func create(presenter: DetailsPresenterProtocol) -> DetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.presenter = presenter
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActivityIndicator()
        presenter.attachView(self)
        presenter.viewDidLoad()
    }

    private func setupCollectionView() {
        view.backgroundColor = .appBackground
        detailsCollection.backgroundColor = .appBackground
        detailsCollection.collectionViewLayout = createLayout()
        detailsCollection.delegate = self
        detailsCollection.dataSource = self
        detailsCollection.register(UpcomingFixtureCell.self, forCellWithReuseIdentifier: "UpcomingFixtureCell")
        detailsCollection.register(LatestFixtureCell.self, forCellWithReuseIdentifier: "LatestFixtureCell")
        detailsCollection.register(TeamCell.self, forCellWithReuseIdentifier: "TeamCell")
        detailsCollection.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0: return self?.upcomingSection()
            case 1: return self?.latestSection()
            case 2: return self?.teamsSection()
            default: return self?.upcomingSection()
            }
        }
    }

    private func upcomingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
        section.boundarySupplementaryItems = [headerItem()]
        return section
    }

    private func latestSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.boundarySupplementaryItems = [headerItem()]
        return section
    }

    private func teamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
        section.boundarySupplementaryItems = [headerItem()]
        return section
    }

    private func headerItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    @objc private func favoriteTapped() {
        presenter.toggleFavorite()
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingFixtureCell", for: indexPath) as! UpcomingFixtureCell
            cell.configure(with: presenter.getUpcomingFixture(at: indexPath.item))
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestFixtureCell", for: indexPath) as! LatestFixtureCell
            cell.configure(with: presenter.getLatestFixture(at: indexPath.item))
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            cell.configure(with: presenter.getTeam(at: indexPath.item))
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as! SectionHeaderView
        header.configure(with: presenter.sectionTitle(for: indexPath.section))
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            presenter.didSelectTeam(at: indexPath.row)
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
   
}

extension DetailsViewController: DetailsView {

    func showLoading() { activityIndicator.startAnimating() }
    func hideLoading() { activityIndicator.stopAnimating() }
    func reloadData() { detailsCollection.reloadData() }
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func setTitle(_ title: String) { self.title = title }
    func setFavoriteState(_ isFavorite: Bool) {
        
        guard presenter.isFavoriteSupported() else {
                navigationItem.rightBarButtonItem = nil
                return
            }
        let imageName = isFavorite ? "heart.fill" : "heart"
        let button = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        button.tintColor = .appPrimary
        navigationItem.rightBarButtonItem = button
    }
    
}
