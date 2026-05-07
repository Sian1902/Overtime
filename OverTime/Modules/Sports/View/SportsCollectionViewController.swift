//
//  SportsCollectionViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

private let reuseIdentifier = "Cell"

class SportsCollectionViewController: UICollectionViewController {
    
    private let presenter : SportsPresenterProtocol
    
    init(presenter : SportsPresenterProtocol) {
        self.presenter = presenter
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(SportsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.backgroundColor = .appBackground
        
        self.title = "Sports"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.appPrimary,
            .font: UIFont.boldSystemFont(ofSize: 22)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        setupFlowLayout()
    }

    private func setupFlowLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 20
            let itemWidth = (view.frame.width - (spacing * 3)) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)
        }
    }
    
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.SportsNumber()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sport = presenter.getSport(at: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SportsCollectionViewCell
        cell.configure(sport)
        
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter.didSelectedSport(at:indexPath.row)
    }
}
extension SportsCollectionViewController : SportsView{
    
}
