//
//  UniversitiesAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class UniversitiesAssembly {
    static func build() -> UIViewController {
        let viewController = UniversitiesViewController()
        let interactor = UniversitiesInteractor()
        let presenter = UniversitiesPresenter()
        let router = UniversitiesRouter()
        let worker = UniversitiesWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        interactor.worker = worker
        
        return viewController
    }
}
