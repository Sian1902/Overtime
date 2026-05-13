//
//  OnboardingViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 13/05/2026.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private let presenter: OnboardingPresenterProtocol
    private var pageViewController: UIPageViewController!
    private var pages: [OnboardingPageViewController] = []

    // MARK: - UI

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .appPrimary
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        pc.isUserInteractionEnabled = false
        return pc
    }()

    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started  →", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .appPrimary
        button.layer.cornerRadius = 28
        button.alpha = 0
        return button
    }()

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return button
    }()

    // MARK: - Init

    init(presenter: OnboardingPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        buildPages()
        setupPageViewController()
        setupControls()
        presenter.attachView(self)
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func buildPages() {
        pages = (0..<presenter.totalPages).map { index in
            OnboardingPageViewController(model: presenter.pageModel(at: index))
        }
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = self
        pageViewController.delegate   = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)

        pageViewController.setViewControllers(
            [pages[0]],
            direction: .forward,
            animated: false
        )
    }

    private func setupControls() {
        view.addSubview(pageControl)
        view.addSubview(getStartedButton)
        view.addSubview(skipButton)

        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            getStartedButton.heightAnchor.constraint(equalToConstant: 56),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -20)
        ])
    }

    @objc private func getStartedTapped() {
        presenter.didTapGetStarted()
    }

    @objc private func skipTapped() {
        presenter.didTapSkip()
    }
}

// MARK: - OnboardingView

extension OnboardingViewController: OnboardingView {

    func displayPage(at index: Int) {
        guard index < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentPageIndex ? .forward : .reverse
        pageViewController.setViewControllers(
            [pages[index]],
            direction: direction,
            animated: true
        )
        currentPageIndex = index
    }

    func updatePageIndicator(current: Int, total: Int) {
        pageControl.numberOfPages = total
        pageControl.currentPage   = current
    }

    func showGetStarted() {
        UIView.animate(withDuration: 0.3) {
            self.getStartedButton.alpha = 1
        }
    }

    func hideGetStarted() {
        UIView.animate(withDuration: 0.3) {
            self.getStartedButton.alpha = 0
        }
    }

    private var currentPageIndex: Int {
        get {
            guard let vc = pageViewController.viewControllers?.first as? OnboardingPageViewController,
                  let index = pages.firstIndex(of: vc) else { return 0 }
            return index
        }
        set { }
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc    = viewController as? OnboardingPageViewController,
              let index = pages.firstIndex(of: vc),
              index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc    = viewController as? OnboardingPageViewController,
              let index = pages.firstIndex(of: vc),
              index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let vc    = pageViewController.viewControllers?.first as? OnboardingPageViewController,
              let index = pages.firstIndex(of: vc) else { return }
        presenter.didChangePage(to: index)
    }
}
