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
        let detailsViewController = UIViewController() // Допустим, у вас есть экран деталей
//        detailsViewController.university = university
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
