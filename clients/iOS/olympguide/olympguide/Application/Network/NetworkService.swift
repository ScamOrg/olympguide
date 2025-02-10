//
//  NetworkService.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

import Foundation

enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem]?,
        body: [String: Any]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
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
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem]?,
        body: [String: Any]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    if !(200...299).contains(httpResponse.statusCode) {
                        if let errorData = decodedData as? BaseServerResponse {
                            if errorData.type == "PreviousCodeNotExpired", let time = errorData.time {
                                completion(.failure(.previousCodeNotExpired(time: time)))
                                return
                            }
                            completion(.failure(.serverError(message: errorData.message)))
                            return
                        }
                    }
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        .resume()
    }
}
