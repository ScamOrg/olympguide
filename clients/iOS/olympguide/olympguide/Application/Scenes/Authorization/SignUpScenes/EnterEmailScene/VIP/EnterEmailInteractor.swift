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
        self.email = request.email
        
        guard isValidEmail(request.email) else {
            let error = NSError(domain: "InvalidEmail", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Некорректный адрес электронной почты"
            ])
            let response = EnterEmailModels.SendCode.Response(success: false, error: error)
            presenter?.presentSendCode(response: response)
            return
        }
        
        worker.sendCode(email: request.email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let baseResponse):
                self.time = baseResponse.time
                let response = EnterEmailModels.SendCode.Response(
                    success: true,
                    error: nil
                )
                self.presenter?.presentSendCode(response: response)
                
            case .failure(let networkError):
                switch networkError {
                case .previousCodeNotExpired(let time):
                    self.time = time
                    let response = EnterEmailModels.SendCode.Response(
                        success: true,
                        error: nil
                    )
                    self.presenter?.presentSendCode(response: response)
                    
                default:
                    let response = EnterEmailModels.SendCode.Response(
                        success: false,
                        error: networkError as NSError
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
