//
//  DirectionsAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import UIKit

final class ProgramAssembly {
    static func build(for univesityID: Int) -> UIViewController {
        let viewController = ProgramsByFieldsViewController(for: univesityID)
        let interactor = ProgramInteractor()
        var presenter = ProgramPresenter()
        var router = ProgramsRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        
        return viewController
    }
}
