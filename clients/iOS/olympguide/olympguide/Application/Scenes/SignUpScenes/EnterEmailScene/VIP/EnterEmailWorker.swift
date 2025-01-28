//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol EnterEmailWorkerLogic {
    func sendCode(
        email: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
}

final class EnterEmailWorker: EnterEmailWorkerLogic {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func sendCode(email: String, completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/send_code"
        let body: [String: Any] = ["email": email]
        
        // Вызываем наш универсальный метод
        networkService.request(
            endpoint: endpoint,
            method: .post,
            queryItems: nil, // в данном случае не нужны
            body: body
        ) { (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let baseResponse):
                completion(.success(baseResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
