//
//  EnterEmailInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class EnterEmailInteractor: EnterEmailBusinessLogic, EnterEmailDataStore {
    
    var presenter: EnterEmailPresentationLogic?
    var worker: EnterEmailWorkerLogic = EnterEmailWorker()
    
    var email: String?
    var time: Int?
    
    func sendCode(request: EnterEmailModels.SendCode.Request) {
        // 1. Сохраняем email в dataStore
        self.email = request.email
        
        // 2. Валидируем email
        guard isValidEmail(request.email) else {
            // Показываем ошибку в презентере
            let error = NSError(domain: "InvalidEmail", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Некорректный адрес электронной почты"
            ])
            let response = EnterEmailModels.SendCode.Response(success: false, error: error)
            presenter?.presentSendCode(response: response)
            return
        }
        
        // 3. Делаем запрос
        worker.sendCode(email: request.email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let baseResponse):
                // Сервер вернул 2xx, значит формально всё ОК.
                // Если хочется, можно посмотреть baseResponse.type/message
                // Вдруг там всё же что-то, но статус 200.
                self.time = baseResponse.time
                let response = EnterEmailModels.SendCode.Response(
                    success: true,
                    error: nil
                )
                self.presenter?.presentSendCode(response: response)
                
            case .failure(let networkError):
                // Проверяем, вдруг это .previousCodeNotExpired?
                switch networkError {
                case .previousCodeNotExpired(let time):
                    // В ТЗ написано, что это «не ошибка» и надо идти дальше
                    self.time = time
                    let response = EnterEmailModels.SendCode.Response(
                        success: true, // можем считать это успехом
                        error: nil
                    )
                    self.presenter?.presentSendCode(response: response)
                    
                default:
                    // Любая другая ошибка: показываем в UI
                    let response = EnterEmailModels.SendCode.Response(
                        success: false,
                        error: networkError as NSError
                        // Можно сконвертить к NSError, если нужн
                    )
                    self.presenter?.presentSendCode(response: response)
                }
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
