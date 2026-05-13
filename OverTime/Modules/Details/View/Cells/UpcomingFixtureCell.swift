import UIKit

class UpcomingFixtureCell: UICollectionViewCell {

    private let homeTeamImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        return iv
    }()

    private let awayTeamImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        return iv
    }()

    private let vsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "VS"
        label.textColor = .appPrimary
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private let homeTeamNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let awayTeamNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 11, weight: .medium)
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
        label.numberOfLines = 2
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
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor

        contentView.addSubview(homeTeamImageView)
        contentView.addSubview(awayTeamImageView)
        contentView.addSubview(vsLabel)
        contentView.addSubview(homeTeamNameLabel)
        contentView.addSubview(awayTeamNameLabel)
        contentView.addSubview(dateTimeLabel)

        NSLayoutConstraint.activate([
            homeTeamImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            homeTeamImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            homeTeamImageView.widthAnchor.constraint(equalToConstant: 50),
            homeTeamImageView.heightAnchor.constraint(equalToConstant: 50),

            awayTeamImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            awayTeamImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            awayTeamImageView.widthAnchor.constraint(equalToConstant: 50),
            awayTeamImageView.heightAnchor.constraint(equalToConstant: 50),

            vsLabel.centerYAnchor.constraint(equalTo: homeTeamImageView.centerYAnchor),
            vsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            homeTeamNameLabel.topAnchor.constraint(equalTo: homeTeamImageView.bottomAnchor, constant: 6),
            homeTeamNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            homeTeamNameLabel.widthAnchor.constraint(equalToConstant: 70),

            awayTeamNameLabel.topAnchor.constraint(equalTo: awayTeamImageView.bottomAnchor, constant: 6),
            awayTeamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            awayTeamNameLabel.widthAnchor.constraint(equalToConstant: 70),

            dateTimeLabel.topAnchor.constraint(equalTo: homeTeamNameLabel.bottomAnchor, constant: 6),
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            dateTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            dateTimeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with fixture: Fixture) {
        homeTeamNameLabel.text = fixture.eventHomeTeam
        awayTeamNameLabel.text = fixture.eventAwayTeam
        dateTimeLabel.text = "\(fixture.eventDate ?? "")\n\(fixture.eventTime ?? "")"
        let placeholder = UIImage(named: "event")
        homeTeamImageView.image = placeholder
        awayTeamImageView.image = placeholder
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
