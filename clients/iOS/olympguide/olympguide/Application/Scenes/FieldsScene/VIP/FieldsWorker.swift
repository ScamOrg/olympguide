//
//  FieldWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

class FieldsWorker {
    
    private enum Constants {
        static let baseURL: String = "https://bf08eca8-0612-472c-95bf-ba00f2795c75.mock.pstmn.io/fields"
        static let invalidURLMessage: String = "Invalid URL"
        static let decodingErrorMessage: String = "Decoding error"
    }
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchFields(degree: String?, search: String?, completion: @escaping (Result<[GroupOfFieldsModel], Error>) -> Void) {
        var queryItems = [URLQueryItem]()

        if let degree = degree {
            queryItems.append(URLQueryItem(name: "sort", value: degree))
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
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let groupsOfFields = try self.decoder.decode([GroupOfFieldsModel].self, from: data)
                completion(.success(groupsOfFields))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NSError(domain: Constants.decodingErrorMessage, code: 0)))
            }
        }.resume()
    }
}
