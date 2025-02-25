//
//  UniversityAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import UIKit

final class UniversityAssembly {
    static func build(for university: UniversityModel) -> UIViewController {
        let viewController = UniversityViewController(for: university)
        let interactor = UniversityInteractor()
        let presenter = UniversityPresenter()
        let router = UniversityRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        return viewController
    }
}
