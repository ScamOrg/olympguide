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
            let viewModel = EnterEmailModels.SendCode.ViewModel(errorMessage: nil)
            viewController?.displaySendCodeResult(viewModel: viewModel)
        } else {
            let errorMessage: String
            
            if let error = response.error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "Произошла неизвестная ошибка"
            }
            
            let viewModel = EnterEmailModels.SendCode.ViewModel(errorMessage: errorMessage)
            viewController?.displaySendCodeResult(viewModel: viewModel)
        }
    }
}
