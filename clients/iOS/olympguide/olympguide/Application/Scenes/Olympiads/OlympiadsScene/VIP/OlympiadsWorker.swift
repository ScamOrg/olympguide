//
//  OlympiadsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation

protocol OlympiadsWorkerLogic {
    func fetchOlympiads(
        with params: [Param],
        completion: @escaping (Result<[OlympiadModel]?, Error>) -> Void
    )
}

final class OlympiadsWorker : OlympiadsWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchOlympiads(
        with params: [Param],
        completion: @escaping (Result<[OlympiadModel]?, Error>) -> Void
    ) {
        var queryItems: [URLQueryItem] = []

        for param in params {
            queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        networkService.request(
            endpoint: "/olympiads",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[OlympiadModel]?, NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
