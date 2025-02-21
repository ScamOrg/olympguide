//
//  FieldsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class FieldsRouter: FieldsRoutingLogic {
    weak var viewController: UIViewController?

    func routeToDetails(for field: GroupOfFieldsModel.FieldModel) {
        let detailsViewController = UIViewController() // Допустим, у вас есть экран деталей
//        detailsViewController.field = field
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchViewController(searchType: .fields)
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
