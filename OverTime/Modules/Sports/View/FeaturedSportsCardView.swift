//
//  FeaturedSportsCardView.swift
//  OverTime
//
//  Created by Mona Zarea on 13/05/2026.
//
import UIKit

final class FeaturedCardHeaderView: UICollectionReusableView {

    static let identifier = "FeaturedCardHeaderView"

    private var featuredCard: FeaturedSportsCardView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with images: [UIImage]) {
        featuredCard?.removeFromSuperview()

        let card = FeaturedSportsCardView(images: images)
        card.translatesAutoresizingMaskIntoConstraints = false
        addSubview(card)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        featuredCard = card
    }
}
class FeaturedSportsCardView: UIView {
    static let identifier = "FeaturedCardHeaderView"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let overlayLabel: UILabel = {
        let label = UILabel()
        label.text = "Where the Real Game Begins"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    private var images: [UIImage] = []
    private var currentIndex = 0
    private var timer: Timer?
    
    init(images: [UIImage]) {
        self.images = images
        super.init(frame: .zero)
        setupUI()
        setupShadow()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(overlayLabel)
        
        imageView.image = images.first
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            overlayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            overlayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        containerView.layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    private func setupShadow() {
        self.layer.shadowColor = UIColor.appPrimary.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.15
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
    }
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.transitionToNextImage()
        }
    }
    
    private func transitionToNextImage() {
        guard !images.isEmpty else { return }
        currentIndex = (currentIndex + 1) % images.count
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.images[self.currentIndex]
        })
    }
    
    deinit {
        timer?.invalidate()
    }
}
