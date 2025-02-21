//
//  SignInProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

// MARK: - Business Logic
protocol SignInBusinessLogic {
    func signIn(_ request: SignInModels.SignIn.Request)
}

// MARK: - Presentation Logic
protocol SignInPresentationLogic {
    func presentSignIn(_ response: SignInModels.SignIn.Response)
}

// MARK: - Display Logic
protocol SignInDisplayLogic: AnyObject {
    func displaySignInResult(_ viewModel: SignInModels.SignIn.ViewModel)
}

// MARK: - Routing Logic
protocol SignInRoutingLogic {
    func routeToRoot()
}

protocol SignInValidationErrorDisplayable {
    var emailTextField: HighlightableField { get }
    var passwordTextField: HighlightableField { get }
}
