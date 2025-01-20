//
//  UniversityWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

class UniversitiesWorker {
    
    private enum Constants {
//        static let baseURL: String = "https://bf08eca8-0612-472c-95bf-ba00f2795c75.mock.pstmn.io/universities"
        static let baseURL: String = ""
        static let invalidURLMessage: String = "Invalid URL"
        static let decodingErrorMessage: String = "Decoding error"
    }
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchUniversities(regionID: Int?, sort: String?, search: String?, completion: @escaping (Result<[UniversityModel], Error>) -> Void) {
        var queryItems = [URLQueryItem]()
        if let regionID = regionID {
            queryItems.append(URLQueryItem(name: "region_id", value: "\(regionID)"))
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
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let universities = try self.decoder.decode([UniversityModel].self, from: data)
                completion(.success(universities))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NSError(domain: Constants.decodingErrorMessage, code: 0)))
            }
        }.resume()
    }
}
