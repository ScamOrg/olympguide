//
//  AuthManager.swift
//  olympguide
//
//  Created by Tom Tim on 18.02.2025.
//

import Foundation
import Combine

class AuthManager {
    static let shared = AuthManager()
    private let baseURL: String
    
    @Published private(set) var isAuthenticated: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL is not set in Info.plist!")
        }
        self.baseURL = baseURLString
        checkSession()
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = [
            "name": username,
            "password": password
        ]
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { ($0.response as? HTTPURLResponse)?.statusCode == 200 }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.isAuthenticated = true
                }
                completion(success)
            }
            .store(in: &cancellables)
    }
    
    func checkSession() {
        let url = URL(string: "\(baseURL)/check-session")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { ($0.response as? HTTPURLResponse)?.statusCode == 200 }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValidSession in
                self?.isAuthenticated = isValidSession
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        let url = URL(string: "\(baseURL)/auth/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { ($0.response as? HTTPURLResponse)?.statusCode == 200 }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.isAuthenticated = false
                }
            }
            .store(in: &cancellables)
    }
}
