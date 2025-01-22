//
//  EnterEmailPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class VerifyEmailPresenter: VerifyEmailPresentationLogic {
    
    weak var viewController: VerifyEmailDisplayLogic?
    
    func presentVerifyCode(response: VerifyEmailModels.SendCode.Response) {
        if response.success {
            // Ошибки нет — значит всё ОК
            let viewModel = VerifyEmailModels.SendCode.ViewModel(errorMessage: nil)
            viewController?.displayVerifyCodeResult(viewModel: viewModel)
        } else {
            // Есть ошибка
            let errorMessage: String
            
            if let error = response.error {
                // Если это NSError, вытащим локализованное описание
                errorMessage = (error as NSError).userInfo[NSLocalizedDescriptionKey] as? String
                    ?? "Произошла неизвестная ошибка"
            } else {
                errorMessage = "Произошла неизвестная ошибка"
            }
            
            let viewModel = VerifyEmailModels.SendCode.ViewModel(errorMessage: errorMessage)
            viewController?.displayVerifyCodeResult(viewModel: viewModel)
        }
    }
}
