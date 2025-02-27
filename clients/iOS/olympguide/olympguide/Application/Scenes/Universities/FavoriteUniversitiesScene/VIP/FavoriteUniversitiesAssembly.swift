//
//  FavoriteUniversitiesAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteUniversitiesAssembly {
    static func build() -> UIViewController {
        let viewController = FavoriteUniversitiesViewController()
        let interactor = UniversitiesInteractor()
        let presenter = UniversitiesPresenter()
        let router = UniversitiesRouter()
        let worker = FavoriteUniversitiesWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        interactor.worker = worker
        
        return viewController
    }
}
