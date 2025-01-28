//
//  EnterEmailPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation
import UIKit

final class VerifyEmailPresenter: VerifyEmailPresentationLogic {
    
    weak var viewController: (UIViewController & VerifyEmailDisplayLogic)?
    
    func presentVerifyCode(response: VerifyEmailModels.VerifyCode.Response) {
        if response.success {
            // Ошибки нет — значит всё ОК
            let viewModel = VerifyEmailModels.VerifyCode.ViewModel(errorMessage: nil)
            viewController?.displayVerifyCodeResult(viewModel: viewModel)
        } else {
            // Есть ошибка
            let errorMessage: String
            
            if let error = response.error {
                errorMessage = error.localizedDescription  // <-- используем localizedDescription
            } else {
                errorMessage = "Произошла неизвестная ошибка"
            }
            
            let viewModel = VerifyEmailModels.VerifyCode.ViewModel(errorMessage: errorMessage)
            viewController?.displayVerifyCodeResult(viewModel: viewModel)
        }
    }
    
    func presentResendCode(response: VerifyEmailModels.ResendCode.Response) {
        if response.success {
            let viewModel = VerifyEmailModels.ResendCode.ViewModel(errorMessage: nil)
            viewController?.displayResendCodeResult(viewModel: viewModel)
        } else {
            let errorMessage: String
            
            if let error = response.error {
                errorMessage = error.localizedDescription  
            } else {
                errorMessage = "Произошла неизвестная ошибка"
            }
            
            let viewModel = EnterEmailModels.SendCode.ViewModel(errorMessage: errorMessage)
            viewController?.showAlert(with: errorMessage)
        }
    }
}
