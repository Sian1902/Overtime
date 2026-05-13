import UIKit

protocol LeagueCellDelegate: AnyObject {
    func didTapFavorite(in cell: LeagueTableViewCell)
}

class LeagueTableViewCell: UITableViewCell {

    weak var delegate: LeagueCellDelegate?

    private let leagueImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = .systemGray6
        iv.layer.borderWidth = 1.5
        iv.layer.borderColor = UIColor.appPrimary.cgColor
        return iv
    }()

    private let leagueNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .appPrimary
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .selected)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .appBackground
        selectionStyle = .none

        contentView.addSubview(leagueImageView)
        contentView.addSubview(leagueNameLabel)
        contentView.addSubview(favoriteButton)

        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            leagueImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leagueImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leagueImageView.widthAnchor.constraint(equalToConstant: 60),
            leagueImageView.heightAnchor.constraint(equalToConstant: 60),
            leagueImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            leagueImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            leagueNameLabel.leadingAnchor.constraint(equalTo: leagueImageView.trailingAnchor, constant: 16),
            leagueNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leagueNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func favoriteTapped() {
        delegate?.didTapFavorite(in: self)
    }

    func configure(with league: League, isFavorite: Bool) {
        leagueNameLabel.text = league.leagueName
        favoriteButton.isSelected = isFavorite

        if let urlString = league.leagueBadge ?? league.leagueLogo,
           let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            leagueImageView.image = UIImage(named: "league")
        }
    }

    func setFavorite(_ isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.leagueImageView.image = image
            }
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        leagueImageView.image = nil
        favoriteButton.isSelected = false
    }
}
