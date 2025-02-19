//
//  SignInInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import Foundation

final class SignInInteractor: SignInBusinessLogic {
    var presenter: SignInPresentationLogic?
    
    func signIn(_ request: SignInModels.SignIn.Request) {
        let email = request.email
        let password = request.password
        guard !email.isEmpty, !password.isEmpty else {
            var validationErrors: [ValidationError] = []
            if email.isEmpty {
                validationErrors.append(.emptyField(fieldName: "email"))
            }
            
            if password.isEmpty {
                validationErrors.append(.emptyField(fieldName: "password"))
            }
            
            let response = SignInModels.SignIn.Response(
                success: false,
                error: AppError.validation(validationErrors)
            )
            
            presenter?.presentSignIn(response)
            return
        }
        
        AuthManager.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let response = SignInModels.SignIn.Response(success: true, error: nil)
                self.presenter?.presentSignIn(response)
            case .failure(let error):
                let response = SignInModels.SignIn.Response(success: false, error: AppError.network(error))
                self.presenter?.presentSignIn(response)
            }
            
        }
    }
}



