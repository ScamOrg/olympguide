//
//  OlympiadsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation

class OlympiadsWorker {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchOlympiads(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[OlympiadModel], Error>) -> Void
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
            endpoint: "/olympiads",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[OlympiadModel], NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
