//
//  Worker.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

protocol FavoriteProgramsWorkerLogic {
    func fetchPrograms(
        completion: @escaping (Result<[ProgramModel], Error>) -> Void
    )
}

class FavoriteProgramsWorker : FavoriteProgramsWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPrograms(
        completion: @escaping (Result<[ProgramModel], Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/favourite/programs",
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<[ProgramModel], NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
