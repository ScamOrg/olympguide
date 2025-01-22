//
//  EnterEmailInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class VerifyEmailInteractor: VerifyEmailBusinessLogic, EnterEmailDataStore {
    
    // MARK: - External properties
    var presenter: VerifyEmailPresentationLogic?
    var worker: VerifyEmailWorkerLogic = VerifyEmailWorker()
    
    // MARK: - EnterEmailDataStore
    var email: String?
    
    // MARK: - EnterEmailBusinessLogic
    func verifyCode(request: VerifyEmailModels.SendCode.Request) {
        // 1. Сохраняем email в dataStore
        self.email = request.email
        
        // 3. Если email валиден — делаем запрос через worker
        worker.verifyCode(email: request.email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                // Ошибка сервера или сети
                let response = VerifyEmailModels.SendCode.Response(success: false, error: error)
                self.presenter?.presentSendCode(response: response)
            } else {
                // Успешно отправили код
                let response = VerifyEmailModels.SendCode.Response(success: true, error: nil)
                self.presenter?.presentSendCode(response: response)
            }
        }
    }
}
