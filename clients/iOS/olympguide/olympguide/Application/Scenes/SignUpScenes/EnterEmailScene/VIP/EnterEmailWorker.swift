//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol EnterEmailWorkerLogic {
    func sendCode(email: String, completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void)
}

final class EnterEmailWorker: EnterEmailWorkerLogic {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func sendCode(email: String, completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/send_code"
        let body: [String: Any] = ["email": email]
        
        networkService.request(endpoint: endpoint, method: "POST", body: body) { result in
            completion(result)
        }
    }
}
