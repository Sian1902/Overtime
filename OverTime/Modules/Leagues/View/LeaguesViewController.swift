import UIKit

class LeagueViewController: UIViewController {

    @IBOutlet weak var leaguesTable: UITableView!

    private var presenter: LeaguePresenterProtocol!
    private var sport: SportType!

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .appPrimary
        ai.hidesWhenStopped = true
        return ai
    }()

    static func create(presenter: LeaguePresenterProtocol, sport: SportType? = nil) -> LeagueViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LeagueViewController") as! LeagueViewController
        vc.presenter = presenter
        vc.sport = sport
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = sport == nil ? "Favorites" : "Leagues"
        presenter.attachView(self)
        activityIndicator.startAnimating()
        presenter.loadLeagues()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadLeagues()
    }
    
    private let emptyStateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "No favorites added yet.\nStart exploring leagues!"
            label.textColor = .lightGray
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.isHidden = true
            return label
        }()

    private func setupUI() {
        view.backgroundColor = .appBackground
        title = "Leagues"
        navigationController?.navigationBar.tintColor = .appPrimary
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .appBackground
        navigationController?.navigationBar.isTranslucent = false

        leaguesTable.backgroundColor = .appBackground
        leaguesTable.separatorColor = UIColor.white.withAlphaComponent(0.1)
        leaguesTable.separatorInset = UIEdgeInsets(top: 0, left: 92, bottom: 0, right: 16)
        leaguesTable.rowHeight = 84
        leaguesTable.delegate = self
        leaguesTable.dataSource = self
        leaguesTable.register(LeagueTableViewCell.self, forCellReuseIdentifier: String(describing: LeagueTableViewCell.self))

        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
    }
}

extension LeagueViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.leaguesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LeagueTableViewCell.self), for: indexPath) as! LeagueTableViewCell
        cell.configure(with: presenter.getLeague(at: indexPath.row), isFavorite: presenter.isFavorite(at: indexPath.row))
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectLeague(at: indexPath.row)
    }
}

extension LeagueViewController: LeagueCellDelegate {
    func didTapFavorite(in cell: LeagueTableViewCell) {
        guard let indexPath = leaguesTable.indexPath(for: cell) else { return }
        presenter.toggleFavorite(at: indexPath.row)
    }
}

extension LeagueViewController: LeagueView {

    func showLeagues(_ leagues: [League]) {
        activityIndicator.stopAnimating()
        leaguesTable.reloadData()
    }

    func showError(_ message: String) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func updateFavoriteButton(at index: Int, isFavorite: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = leaguesTable.cellForRow(at: indexPath) as? LeagueTableViewCell else { return }
        cell.setFavorite(isFavorite)
    }
    
    func showEmptyState(_ isVisible: Bool) {
            emptyStateLabel.isHidden = !isVisible
            leaguesTable.isHidden = isVisible
        }
}
