import UIKit

class TeamCell: UICollectionViewCell {

    private let teamImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 35
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.appPrimary.cgColor
        return iv
    }()

    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 11, weight: .medium)
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
        contentView.backgroundColor = .clear
        contentView.addSubview(teamImageView)
        contentView.addSubview(teamNameLabel)

        NSLayoutConstraint.activate([
            teamImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            teamImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            teamImageView.widthAnchor.constraint(equalToConstant: 70),
            teamImageView.heightAnchor.constraint(equalToConstant: 70),

            teamNameLabel.topAnchor.constraint(equalTo: teamImageView.bottomAnchor, constant: 6),
            teamNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            teamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            teamNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with team: Team) {
        teamNameLabel.text = team.teamName
        print("🏆 Team: \(team.teamName ?? "") badge: \(team.teamBadge ?? "nil")")
        if let urlString = team.teamBadge, !urlString.isEmpty, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            teamImageView.image = UIImage(systemName: "person.3.fill")
        }
    }	

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { self?.teamImageView.image = image }
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        teamImageView.image = nil
    }
}
