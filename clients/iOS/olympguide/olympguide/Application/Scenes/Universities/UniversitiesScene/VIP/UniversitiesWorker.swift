//
//  UniversityWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

class UniversitiesWorker {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchUniversities(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[UniversityModel], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
//        if let levels = levels {
//            for level in levels {
//                queryItems.append(URLQueryItem(name: "level", value: "\(level)"))
//            }
//        }
//        if let sort = sort {
//            queryItems.append(URLQueryItem(name: "sort", value: sort))
//        }
//        if let search = search {
//            queryItems.append(URLQueryItem(name: "search", value: search))
//        }
        
        networkService.request(
            endpoint: "/universities",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[UniversityModel], NetworkError>) in
            switch result {
            case .success(let universities):
                completion(.success(universities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
