//
//  SplashViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

final class SplashViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var overtimeLabel: UILabel!
    private let presenter: SplashPresenterProtocol

    init(presenter: SplashPresenterProtocol, nibName : String ) {
        self.presenter = presenter
        super.init(nibName: nibName, bundle: nil)

    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpUi()
        setUpInitialState()
        startAnimation()
    }
    
    func setUpUi(){
        view.backgroundColor = .appBackground
        overtimeLabel.textColor = .appPrimary
        
        let text = "OverTime"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont.splashTitile, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.kern, value: 1.2, range: NSRange(location: 0, length: text.count))
        overtimeLabel.attributedText = attributedString
    }
    
    func setUpInitialState(){
        logoImage.alpha = 0
        overtimeLabel.alpha = 0
        logoImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    func startAnimation(){
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.logoImage.alpha = 1
            self.overtimeLabel.alpha=1
            self.logoImage.transform = .identity
        }){ [weak self] finished in
            if finished{
                self?.presenter.animationDidFinished()
            }
        }
    }
    
    private func setUpConstraints() {
            logoImage.translatesAutoresizingMaskIntoConstraints = false
            overtimeLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                logoImage.widthAnchor.constraint(equalToConstant: 150),
                logoImage.heightAnchor.constraint(equalToConstant: 150),
                logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
                
                overtimeLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
                overtimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
}

extension SplashViewController: SplashView {
    
}
