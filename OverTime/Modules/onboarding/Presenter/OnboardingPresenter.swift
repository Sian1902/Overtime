//
//  OnboardingPresenter.swift
//  OverTime
//
//  Created by Mona Zarea on 13/05/2026.
//

import Foundation

final class OnboardingPresenter: OnboardingPresenterProtocol {

    private weak var view: OnboardingView?
    private let router: AppRouterProtocol
    private let storage: UserDefaultsManagerProtocol

    private var currentIndex = 0

    private let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            backgroundImage: "onboarding1",
            badge: "ELITE PERFORMANCE",
            title: "Track Every Moment",
            description: "Experience real-time analytics and high-velocity data from the world's most elite racing circuits."
        ),
        OnboardingPageModel(
            backgroundImage: "onboarding2",
            badge: "LIVE SCORES",
            title: "Never Miss a Game",
            description: "Get live scores and updates from every league around the world in real time."
        ),
        OnboardingPageModel(
            backgroundImage: "onboarding3",
            badge: "YOUR FAVORITES",
            title: "Follow What You Love",
            description: "Save your favorite leagues and teams and get personalized updates."
        )
    ]

    init(router: AppRouterProtocol, storage: UserDefaultsManagerProtocol) {
        self.router  = router
        self.storage = storage
    }

    func attachView(_ view: OnboardingView) {
        self.view = view
    }

    var totalPages: Int { pages.count }

    func pageModel(at index: Int) -> OnboardingPageModel {
        pages[index]
    }

    func viewDidLoad() {
        view?.displayPage(at: 0)
        view?.updatePageIndicator(current: 0, total: pages.count)
        view?.hideGetStarted()
    }

    func didChangePage(to index: Int) {
        currentIndex = index
        view?.updatePageIndicator(current: index, total: pages.count)

        if index == pages.count - 1 {
            view?.showGetStarted()
        } else {
            view?.hideGetStarted()
        }
    }

    func didTapNext() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            view?.displayPage(at: currentIndex)
            view?.updatePageIndicator(current: currentIndex, total: pages.count)

            if currentIndex == pages.count - 1 {
                view?.showGetStarted()
            }
        }
    }

    func didTapSkip() {
        finishOnboarding()
    }

    func didTapGetStarted() {
        finishOnboarding()
    }

    private func finishOnboarding() {
        storage.hasSeenOnboarding = true
        router.showMainTabBar()
    }
  
}
