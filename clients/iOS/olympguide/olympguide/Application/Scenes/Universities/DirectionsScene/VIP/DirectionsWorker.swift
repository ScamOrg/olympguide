//
//  DirectionsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
protocol WorkerLogic {
    func fetch(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[Model], Error>) -> Void
    )
}

class Worker : WorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetch(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[Model], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        networkService.request(
            endpoint: "",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[Model], NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
