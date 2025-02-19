//
//  SignInPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import Foundation

final class SignInPresenter : SignInPresentationLogic {
    weak var viewController: (SignInDisplayLogic & SignInValidationErrorDisplayable)?
    
    func presentSignIn(_ response: SignInModels.SignIn.Response) {
        if response.success {
            let viewModel = SignInModels.SignIn.ViewModel(success: true, errorMessages: nil)
            viewController?.displaySignInResult(viewModel)
            return
        }
        
        var errorMessages: [String] = []
        
        if let error = response.error as? AppError {
            switch error {
            case .network(let networkError):
                errorMessages.append(networkError.localizedDescription)
            case .validation(let validationErrors):
                break
            }
            highlightValidationErrors(error)
        } else {
            errorMessages.append("Произошла неизвестная ошибка")
        }
        
        let viewModel = SignInModels.SignIn.ViewModel(
            success: false,
            errorMessages: errorMessages
        )
        viewController?.displaySignInResult(viewModel)
    }
    
    
    private func highlightValidationErrors(_ error: AppError) {
        switch error {
        case .validation(let validationErrors):
            for er in validationErrors {
                switch er {
                case .emptyField(fieldName: "email"):
                    viewController?.emailTextField.highlightError()
                case .emptyField(fieldName: "password"):
                    viewController?.passwordTextField.highlightError()
                default:
                    break
                }
            }
        case .network(let networkError):
            switch networkError {
            case .userNotFound:
                viewController?.emailTextField.highlightError()
            case .invalidPassword:
                viewController?.passwordTextField.highlightError()
            default:
                break
            }
        }
    }
}
