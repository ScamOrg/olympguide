//
//  UniversitiesRouter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class UniversitiesRouter: UniversitiesRoutingLogic {
    weak var viewController: UIViewController?

    func routeToDetails(for university: UniversityModel) {
        let detailsViewController = ViewController()  
//        detailsViewController.university = university
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchViewController(searchType: .universities)
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
