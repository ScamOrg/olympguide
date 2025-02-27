//
//  FavoriteOlympiadsAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteOlympiadsAssembly {
    static func build() -> UIViewController {
        let viewController = FavoriteOlympiadsViewController()
        let interactor = OlympiadsInteractor()
        let presenter = OlympiadsPresenter()
        let router = OlympiadsRouter()
        let worker = FavoriteOlympiadsWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        interactor.worker = worker
        
        return viewController
    }
}
