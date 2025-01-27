//
//  EnterEmailInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class VerifyEmailInteractor: VerifyEmailBusinessLogic, VerifyEmailDataStore {
    
    // MARK: - External properties
    var presenter: VerifyEmailPresentationLogic?
    var worker: VerifyEmailWorkerLogic = VerifyEmailWorker()
    
    // MARK: - DataStore
    var email: String?
    
    // MARK: - VerifyEmailBusinessLogic
    func verifyCode(request: VerifyEmailModels.VerifyCode.Request) {
        // Сохраняем email в dataStore (если нужно для дальнейшей логики)
        self.email = request.email
        
        // Делаем запрос на верификацию
        worker.verifyCode(code: request.code, email: request.email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                // Успешно (статус 2xx). Параметры в BaseServerResponse,
                // если они нужны — можно использовать.
                let response = VerifyEmailModels.VerifyCode.Response(
                    success: true,
                    error: nil
                )
                self.presenter?.presentVerifyCode(response: response)
                
            case .failure(let networkError):
                // Сюда приходит любая ошибка, включая .serverError, .decodingError, .unknown и т.д.
                // Если нужно, можно «свичевать» внутри этой ветки и обрабатывать отдельные кейсы
                // (например, previousCodeNotExpired). Но здесь пример упрощённый.
                
                let response = VerifyEmailModels.VerifyCode.Response(
                    success: false,
                    // Если презентеру важен NSError, можно сконвертировать:
                    error: networkError as NSError
                )
                self.presenter?.presentVerifyCode(response: response)
            }
        }
    }
}
