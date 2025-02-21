//
//  SignInAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class SignInAssembly {
    static func build() -> UIViewController {
        let viewController = SignInViewController()
        let interactor =  SignInInteractor()
        let presenter = SignInPresenter()
        interactor.presenter = presenter
        let router = SignInRouter()
        router.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
        presenter.viewController = viewController
        
        return viewController
    }
}

