//
//  EnterEmailInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class EnterEmailInteractor: EnterEmailBusinessLogic, EnterEmailDataStore {
    
    // MARK: - External properties
    var presenter: EnterEmailPresentationLogic?
    var worker: EnterEmailWorkerLogic = EnterEmailWorker()
    
    // MARK: - EnterEmailDataStore
    var email: String?
    
    // MARK: - EnterEmailBusinessLogic
    func sendCode(request: EnterEmailModels.SendCode.Request) {
        // 1. Сохраняем email в dataStore
        self.email = request.email
        
        // 2. Валидируем email
        guard isValidEmail(request.email) else {
            let error = NSError(domain: "InvalidEmail", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Некорректный адрес электронной почты"
            ])
            let response = EnterEmailModels.SendCode.Response(success: false, error: error)
            presenter?.presentSendCode(response: response)
            return
        }
        
        // 3. Если email валиден — делаем запрос через worker
        worker.sendCode(email: request.email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                // Ошибка сервера или сети
                let response = EnterEmailModels.SendCode.Response(success: false, error: error)
                self.presenter?.presentSendCode(response: response)
            } else {
                // Успешно отправили код
                let response = EnterEmailModels.SendCode.Response(success: true, error: nil)
                self.presenter?.presentSendCode(response: response)
            }
        }
    }
    
    // MARK: - Private
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
