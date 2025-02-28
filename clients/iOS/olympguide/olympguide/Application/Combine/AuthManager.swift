//
//  AuthManager.swift
//  olympguide
//
//  Created by Tom Tim on 18.02.2025.
//

import Foundation
import Combine

import Foundation
import Combine

class AuthManager {
    static let shared = AuthManager(networkService: NetworkService())

    private let networkService: NetworkServiceProtocol
    @Published private(set) var isAuthenticated: Bool = false
    
    private let baseURL: String
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol) {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL is not set in Info.plist!")
        }
        self.baseURL = baseURLString
        self.networkService = networkService
    }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        networkService.request(
            endpoint: "/auth/login",
            method: .post,
            queryItems: nil,
            body: body,
            completion: { [weak self] (result: Result<BaseServerResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    self?.isAuthenticated = true
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    func checkSession() {
        networkService.request(
            endpoint: "/auth/check-session",
            method: .get,
            queryItems: nil,
            body: nil
        ) { [weak self] (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success:
                self?.isAuthenticated = true
            case .failure:
                self?.isAuthenticated = false
            }
        }
    }
    
    func logout(completion: ((Result<BaseServerResponse, NetworkError>) -> Void)? = nil) {
        networkService.request(
            endpoint: "/auth/logout",
            method: .post,
            queryItems: nil,
            body: nil
        ) { [weak self] (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self?.isAuthenticated = false
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
