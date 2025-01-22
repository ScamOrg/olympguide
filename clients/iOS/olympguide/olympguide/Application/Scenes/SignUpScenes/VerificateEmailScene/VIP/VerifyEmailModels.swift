//
//  EnterEmailModels.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

enum VerifyEmailModels {
    enum SendCode {
        struct Request {
            let code: Int
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
