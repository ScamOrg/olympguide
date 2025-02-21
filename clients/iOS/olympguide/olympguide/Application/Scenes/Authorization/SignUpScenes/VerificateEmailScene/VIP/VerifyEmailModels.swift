//
//  EnterEmailModels.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

enum VerifyEmailModels {
    enum VerifyCode {
        struct Request {
            let code: String
            let email: String
        }
        
        struct Response {
            let success: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let errorMessage: String?
        }
    }
    
    enum ResendCode {
        struct Request {
            let email: String
        }
        
        struct Response {
            let success: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let errorMessage: String?
        }
    }
}
