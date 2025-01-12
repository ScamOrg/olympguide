//
//  OlympiadsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation

class OlympiadsWorker {
    
    private enum Constants {
        static let baseURL: String = "http://localhost:8080/olympiads"
        static let invalidURLMessage: String = "Invalid URL"
        static let decodingErrorMessage: String = "Decoding error"
    }
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchOlympiads(levels: [Int]?, sort: String?, search: String?, completion: @escaping (Result<[OlympiadModel], Error>) -> Void) {
        var queryItems = [URLQueryItem]()
        if let levels = levels {
            for level in levels {
                queryItems.append(URLQueryItem(name: "level", value: "\(level)"))
            }
        }
        if let sort = sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        if let search = search {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        var urlComponents = URLComponents(string: Constants.baseURL)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            completion(.failure(NSError(domain: Constants.invalidURLMessage, code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            print("DataTask started")
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let olympiads = try self.decoder.decode([OlympiadModel].self, from: data)
                completion(.success(olympiads))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NSError(domain: Constants.decodingErrorMessage, code: 0)))
            }
        }.resume()
    }
}
