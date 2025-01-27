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

// Можно сделать класс, который будет знать базовый URL, общие хедеры и т.д.
final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "http://5.34.212.145:8080"
    
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
                        // Если статус-код не 2xx, считаем, что это ошибка
                        // Но проверяем, не является ли это нашим "previousCodeNotExpired"
                        if baseResponse.type == "PreviousCodeNotExpired", let time = baseResponse.time {
                            completion(.failure(.previousCodeNotExpired(time: time)))
                            return
                        }
                        
                        // Любая другая ошибка
                        completion(.failure(.serverError(message: baseResponse.message)))
                        return
                    }
                    
                    // Если 2xx
                    completion(.success(baseResponse))
                    
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
