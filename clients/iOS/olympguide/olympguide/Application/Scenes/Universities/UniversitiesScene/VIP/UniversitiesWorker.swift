//
//  UniversityWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

protocol UniversitiesWorkerLogic {
    func fetchUniversities(
        with params: [Param],
        completion: @escaping (Result<[UniversityModel]?, Error>) -> Void
    )
}

final class UniversitiesWorker : UniversitiesWorkerLogic {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchUniversities(
        with params: [Param],
        completion: @escaping (Result<[UniversityModel]?, Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        for param in params {
            queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        networkService.request(
            endpoint: "/universities",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[UniversityModel]?, NetworkError>) in
            switch result {
            case .success(let universities):
                completion(.success(universities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
