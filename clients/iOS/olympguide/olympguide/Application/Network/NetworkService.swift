//
//  NetworkService.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request(
        endpoint: String,
        method: String,
        body: [String: Any]?,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    
    init() {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL is not set in Info.plist!")
        }
        self.baseURL = baseURLString
    }
    func request(
        endpoint: String,
        method: String,
        body: [String: Any]?,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Формируем body
        if let body = body {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = data
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // Сначала проверяем саму сетевую ошибку
                if let error = error {
                    completion(.failure(.unknown(message: error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknown(message: "No HTTP response")))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                // Парсим JSON в BaseServerResponse
                do {
                    let baseResponse = try JSONDecoder().decode(BaseServerResponse.self, from: data)
                    
                    // Дополнительно смотрим статус-код:
                    if !(200...299).contains(httpResponse.statusCode) {
                        if baseResponse.type == "PreviousCodeNotExpired", let time = baseResponse.time {
                            completion(.failure(.previousCodeNotExpired(time: time)))
                            return
                        }
                        completion(.failure(.serverError(message: baseResponse.message)))
                        return
                    }
                    completion(.success(baseResponse))
                    
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
