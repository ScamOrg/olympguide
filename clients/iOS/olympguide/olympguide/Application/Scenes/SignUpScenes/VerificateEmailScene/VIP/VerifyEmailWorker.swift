//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol VerifyEmailWorkerLogic {
    func verifyCode(code: Int, email: String, completion: @escaping (Error?) -> Void)
}

final class VerifyEmailWorker: VerifyEmailWorkerLogic {
    
    func verifyCode(code: Int, email: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "http://5.34.212.145:8080/auth/verify_code") else {
            DispatchQueue.main.async {
                completion(NSError(domain: "InvalidURL", code: 0))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = ["code": code, "email": email]
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = data
        } catch {
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
        task.resume()
    }
}
