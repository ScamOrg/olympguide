//
//  EnterEmailPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class EnterEmailPresenter: EnterEmailPresentationLogic {
    
    weak var viewController: EnterEmailDisplayLogic?
    
    func presentSendCode(response: EnterEmailModels.SendCode.Response) {
        if response.success {
            // Ошибки нет — значит всё ОК
            let viewModel = EnterEmailModels.SendCode.ViewModel(errorMessage: nil)
            viewController?.displaySendCodeResult(viewModel: viewModel)
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
            
            let viewModel = EnterEmailModels.SendCode.ViewModel(errorMessage: errorMessage)
            viewController?.displaySendCodeResult(viewModel: viewModel)
        }
    }
}
