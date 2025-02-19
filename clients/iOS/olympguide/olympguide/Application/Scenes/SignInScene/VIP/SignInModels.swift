//
//  SignInModels.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

enum SignInModels {
    enum SignIn {
        struct Request {
            let email: String
            let password: String
        }
        
        struct Response {
            let success: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let success: Bool
            let errorMessages: [String]?
        }
    }
}


