import UIKit

class LatestFixtureCell: UICollectionViewCell {

    private let homeTeamImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 22
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        return iv
    }()

    private let awayTeamImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 22
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        return iv
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appPrimary
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let homeTeamNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let awayTeamNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor

        contentView.addSubview(homeTeamImageView)
        contentView.addSubview(awayTeamImageView)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(homeTeamNameLabel)
        contentView.addSubview(awayTeamNameLabel)
        contentView.addSubview(dateTimeLabel)

        NSLayoutConstraint.activate([
            homeTeamImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            homeTeamImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            homeTeamImageView.widthAnchor.constraint(equalToConstant: 44),
            homeTeamImageView.heightAnchor.constraint(equalToConstant: 44),

            homeTeamNameLabel.leadingAnchor.constraint(equalTo: homeTeamImageView.trailingAnchor, constant: 6),
            homeTeamNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            homeTeamNameLabel.widthAnchor.constraint(equalToConstant: 70),

            scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            dateTimeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateTimeLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),

            awayTeamNameLabel.trailingAnchor.constraint(equalTo: awayTeamImageView.leadingAnchor, constant: -6),
            awayTeamNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            awayTeamNameLabel.widthAnchor.constraint(equalToConstant: 70),

            awayTeamImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            awayTeamImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            awayTeamImageView.widthAnchor.constraint(equalToConstant: 44),
            awayTeamImageView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configure(with fixture: Fixture) {
        homeTeamNameLabel.text = fixture.eventHomeTeam
        awayTeamNameLabel.text = fixture.eventAwayTeam
        scoreLabel.text = fixture.eventFinalResult ?? "- : -"
        dateTimeLabel.text = "\(fixture.eventDate ?? "") \(fixture.eventTime ?? "")"
        if let url = URL(string: fixture.homeTeamLogo ?? "") { loadImage(into: homeTeamImageView, from: url) }
        if let url = URL(string: fixture.awayTeamLogo ?? "") { loadImage(into: awayTeamImageView, from: url) }
    }

    private func loadImage(into imageView: UIImageView, from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { imageView.image = image }
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        homeTeamImageView.image = nil
        awayTeamImageView.image = nil
    }
}
