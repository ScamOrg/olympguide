//
//  SignUpAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class EnterEmailAssembly {
    static func build() -> UIViewController {
        let viewController = EnterEmailViewController()
        let interactor = EnterEmailInteractor()
        let presenter = EnterEmailPresenter()
        let router = EnterEmailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
}
