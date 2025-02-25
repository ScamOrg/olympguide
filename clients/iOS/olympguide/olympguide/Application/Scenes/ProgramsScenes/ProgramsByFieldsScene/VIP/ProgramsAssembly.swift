//
//  DirectionsAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import UIKit

final class ProgramsByFieldsAssembly {
    static func build(for univesity: UniversityModel) -> UIViewController {
        let viewController = ProgramsViewController(for: univesity)
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let router = ProgramsRouter()
        let worker = ProgramsByFieldsWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        
        return viewController
    }
}

final class ProgramsByFacultiesAssembly {
    static func build(for univesity: UniversityModel) -> UIViewController {
        let viewController = ProgramsViewController(for: univesity)
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let router = ProgramsRouter()
        let worker = ProgramsByFacultiesWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        
        return viewController
    }
}
