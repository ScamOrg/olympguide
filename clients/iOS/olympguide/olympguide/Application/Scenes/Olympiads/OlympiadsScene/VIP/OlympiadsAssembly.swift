//
//  OlympiadsAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class OlympiadsAssembly {
    static func build() -> UIViewController {
        let viewController = OlympiadsViewController()
        let interactor = OlympiadsInteractor()
        let presenter = OlympiadsPresenter()
        let router = OlympiadsRouter()
        let worker = OlympiadsWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        interactor.worker = worker
        
        return viewController
    }
}
