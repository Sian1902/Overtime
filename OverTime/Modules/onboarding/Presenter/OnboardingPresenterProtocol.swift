//
//  OnboardingPresenterProtocol.swift
//  OverTime
//
//  Created by Mona Zarea on 13/05/2026.
//

import Foundation

protocol OnboardingPresenterProtocol: AnyObject {
    func attachView(_ view: OnboardingView)
    func viewDidLoad()

    var totalPages: Int { get }
    func pageModel(at index: Int) -> OnboardingPageModel

    func didTapNext()
    func didTapSkip()
    func didTapGetStarted()
    func didChangePage(to index: Int)
}
