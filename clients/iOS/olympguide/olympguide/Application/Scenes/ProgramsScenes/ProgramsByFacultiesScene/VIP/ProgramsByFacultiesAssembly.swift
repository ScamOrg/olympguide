//
//  DirectionsAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import UIKit

final class ProgramsByFacultiesAssembly {
    static func build(for univesity: UniversityModel) -> UIViewController {
        let viewController = ProgramsByFacultiesViewController(for: univesity)
        let interactor = ProgramsByFacultiesInteractor()
        let presenter = ProgramsByFacultiesPresenter()
        let router = ProgramsByFacultiesRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        
        return viewController
    }
}
