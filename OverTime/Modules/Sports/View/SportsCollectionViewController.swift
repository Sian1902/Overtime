//
//  SportsCollectionViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

private let reuseIdentifier = "Cell"

class SportsCollectionViewController: UICollectionViewController {
    private let featuredimges =  [
            UIImage(named: "sport4")!,
            UIImage(named: "sport2")!,
            UIImage(named: "sport3")!,
            UIImage(named: "sport5")!,
            UIImage(named: "sport1")!
        ]
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
        setupNavigationBar()
        setupCollectionView()
        setupFlowLayout()
        
    }
    private func setupNavigationBar() {
            title = "Sports"
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .appBackground
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.appPrimary,
                .font: UIFont.boldSystemFont(ofSize: 22)
            ]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    
    private func setupCollectionView() {
            collectionView.backgroundColor = .appBackground
            collectionView.register(
                SportsCollectionViewCell.self,
                forCellWithReuseIdentifier: SportsCollectionViewCell.identifier
            )
            collectionView.register(
                FeaturedCardHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: FeaturedCardHeaderView.identifier
            )
        }


    private func setupFlowLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 20
            let itemWidth = (view.frame.width - (spacing * 3)) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)

        }
    }
    
}
extension SportsCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        presenter.SportsNumber()
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportsCollectionViewCell.identifier,
            for: indexPath
        ) as! SportsCollectionViewCell

        cell.configure(presenter.getSport(at: indexPath.row))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FeaturedCardHeaderView.identifier,
            for: indexPath
        ) as! FeaturedCardHeaderView

        header.configure(with: featuredimges)
        return header
    }
}


extension SportsCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let nav = navigationController else { return }
        presenter.didSelectedSport(at: indexPath.row, navigationController: nav)
    }
}


extension SportsCollectionViewController: SportsView {}
