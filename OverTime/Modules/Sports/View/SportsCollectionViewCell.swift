//
//  SportsCollectionViewCell.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

import UIKit

class SportsCollectionViewCell: UICollectionViewCell {
    
    
    let sportImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(sportImageView)
        contentView.addSubview(titleLabel)
        
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        NSLayoutConstraint.activate([
            sportImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            sportImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sportImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sportImageView.heightAnchor.constraint(equalTo: sportImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: sportImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        titleLabel.textColor = .white
    }
    private func setupLayer() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
            
        contentView.layer.borderColor = UIColor.appPrimary.cgColor
            self.layer.shadowColor = UIColor.appPrimary.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.layer.shadowRadius = 6
            self.layer.shadowOpacity = 0.1
            self.layer.masksToBounds = false
        }
    func configure(_ sport : Sport){
        self.sportImageView.image = UIImage(named: sport.imageName)
        self.titleLabel.text = sport.name
        self.sportImageView.image = UIImage(named: sport.imageName)
        self.titleLabel.text = sport.name
        self.sportImageView.backgroundColor = .systemGray5
        
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 12
    }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        }
}
