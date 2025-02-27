//
//  Assembly.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteProgramsAssembly {
    static func build() -> UIViewController {
        let viewController = FavoriteProgramsViewController()
        let interactor = FavoriteProgramsInteractor()
        let presenter = FavoriteProgramsPresenter()
        let router = FavoriteProgramsRouter()
        let worker = FavoriteProgramsWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        
        return viewController
    }
}
