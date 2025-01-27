//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol VerifyEmailWorkerLogic {
    func verifyCode(code: String,
                    email: String,
                    completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void)
}

final class VerifyEmailWorker: VerifyEmailWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    // Позволяем внедрять NetworkService извне (для тестов или мока).
    // Или используем дефолтный, если ничего не передали.
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func verifyCode(code: String,
                    email: String,
                    completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/verify_code"
        let body: [String: Any] = [
            "code": code,
            "email": email
        ]
        
        networkService.request(endpoint: endpoint, method: "POST", body: body) { result in
            // Просто пробрасываем результат наружу
            completion(result)
        }
    }
}
