//
//  OnboardingPageViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 13/05/2026.
//
import UIKit

final class OnboardingPageViewController: UIViewController {

    private let model: OnboardingPageModel

    // MARK: - UI

    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let overlayView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        return v
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .appPrimary
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.appPrimary.cgColor
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.text = "BADGE"
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(model: OnboardingPageModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure(with: model)
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(badgeLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            badgeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            badgeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            badgeLabel.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -12),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -220)
        ])

        badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
    }

    private func configure(with model: OnboardingPageModel) {
        backgroundImageView.image = UIImage(named: model.backgroundImage)
        badgeLabel.text = "  \(model.badge)  "   // padding via spaces
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
