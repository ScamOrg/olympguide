//
//  UniversityWorker.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

protocol UniversityWorkerLogic {
    func fetchUniverity(
        with universityID: Int,
        completion: @escaping (Result<UniversityModel, NetworkError>) -> Void
    )
}

class UniversityWorker : UniversityWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchUniverity(
        with universityID: Int,
        completion: @escaping (Result<UniversityModel, NetworkError>) -> Void
    ) {
        networkService.request(
            endpoint: "/university/\(universityID)",
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<UniversityModel, NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

