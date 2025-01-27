//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol VerifyEmailWorkerLogic {
    func verifyCode(code: String, email: String, completion: @escaping (Error?) -> Void)
}

final class VerifyEmailWorker: VerifyEmailWorkerLogic {
    
    func verifyCode(code: String, email: String, completion: @escaping (Error?) -> Void) {
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
                // 1. Сначала проверяем, не пришла ли именно сетевая ошибка
                if let error = error {
                    completion(error)
                    return
                }
                
                // 2. Проверяем код ответа (HTTP status code)
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(NSError(domain: "NoHTTPURLResponse", code: 0))
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        do {
                            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let errorMessage = dict?["error"] as? String {
                                let serverError = NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                                completion(serverError)
                                return
                            }
                        } catch {
                            // Ошибка парсинга
                            completion(error)
                            return
                        }
                    }
                    
                    // Если вдруг нет тела или в нём не оказалось поля "error"
                    let statusError = NSError(
                        domain: "ServerError",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey : "Unknown server error"]
                    )
                    completion(statusError)
                    return
                }
                
                // Если дошли до этого места, значит статус код 2xx и сетевой ошибки нет.
                // Можно считать, что запрос «успешный» в терминах бэкенда
                completion(nil)
            }
        }
        task.resume()
    }
}
