//
//  OlympiadsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit

final class OlympiadsRouter: OlympiadsRoutingLogic {
    weak var viewController: UIViewController?

    func routeToDetails(for university: OlympiadModel) {
        let detailsViewController = UIViewController() // Допустим, у вас есть экран деталей
//        detailsViewController.university = university
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchViewController(searchType: .olympiads)
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
