//
//  OnboardingView.swift
//  OverTime
//
//  Created by Mona Zarea on 13/05/2026.
//
import Foundation

protocol OnboardingView: AnyObject {
    func displayPage(at index: Int)
    func updatePageIndicator(current: Int, total: Int)
    func showGetStarted()
    func hideGetStarted()      
}
