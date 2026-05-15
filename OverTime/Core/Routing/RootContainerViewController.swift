//
//  RootContainerViewController.swift
//  OverTime
//
//  Created by Mona Zarea on 09/05/2026.
//

import UIKit

final class RootContainerViewController: UIViewController {

    private(set) var currentChild: UIViewController? 

    func transition(to newChild: UIViewController) {
        if let current = currentChild {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }

        addChild(newChild)
        newChild.view.frame = view.bounds
        newChild.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(newChild.view)
        newChild.didMove(toParent: self)

        currentChild = newChild
    }

    func transition(to newChild: UIViewController, duration: TimeInterval) {
        guard let current = currentChild else {
            transition(to: newChild)
            return
        }

        addChild(newChild)
        newChild.view.frame = view.bounds
        newChild.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newChild.view.alpha = 0

        transition(
            from: current,
            to: newChild,
            duration: duration,
            options: .curveEaseInOut,
            animations: {
                newChild.view.alpha = 1
                current.view.alpha = 0
            },
            completion: { [weak self] _ in
                current.willMove(toParent: nil)
                current.removeFromParent()
                newChild.didMove(toParent: self)
                self?.currentChild = newChild
            }
        )
    }
}
