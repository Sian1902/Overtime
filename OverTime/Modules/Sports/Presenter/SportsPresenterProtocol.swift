//
//  SportsPresenterProtocol.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//
import UIKit
import Foundation

protocol SportsPresenterProtocol {
    func attachView(_ view: SportsView)
    func didSelectedSport(at index: Int, navigationController: UINavigationController)
    func SportsNumber() -> Int
    func getSport(at index: Int) -> Sport
}
