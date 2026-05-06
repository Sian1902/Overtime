//
//  SplashViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

final class SplashViewController: UIViewController {

    private let presenter: SplashPresenterProtocol

    init(presenter: SplashPresenterProtocol, nibName : String ) {
        self.presenter = presenter
        super.init(nibName: nibName, bundle: nil)

    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoad()
    }
}

extension SplashViewController: SplashView {
    
}
