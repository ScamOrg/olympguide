//
//  FieldsAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import UIKit

final class FieldsAssembly {
    static func build() -> UIViewController {
        let viewController = FieldsViewController()
        let interactor = FieldsInteractor()
        let presenter = FieldsPresenter()
        let router = FieldsRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        return viewController
    }
}
