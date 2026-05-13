//
//  SplashViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

final class SplashViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!

    private let presenter: SplashPresenterProtocol

    init(presenter: SplashPresenterProtocol, nibName: String) {
        self.presenter = presenter
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        setUpUi()
        setUpInitialState()
        startAnimation()
    }

    func setUpUi() {
        view.backgroundColor = .appBackground

        logoImage.image = UIImage(named: "Logo")
        logoImage.contentMode = .scaleAspectFit
    }

    func setUpInitialState() {
        logoImage.alpha = 0
    }

    func startAnimation() {
        UIView.animate(
            withDuration: 1.5,
            delay: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.logoImage.alpha = 1
                self.logoImage.transform = .identity
            }
        ) { [weak self] finished in
            if finished {
                self?.presenter.animationDidFinished()
            }
        }
    }

    private func setUpConstraints() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 750),
            logoImage.heightAnchor.constraint(equalToConstant: 750),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController: SplashView {

}
