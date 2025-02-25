//
//  DirectionsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
protocol ProgramsWorkerLogic {
    func fetch(
        with params: [Param],
        for universityId: Int,
        completion: @escaping (Result<[GroupOfProgramsModel], Error>) -> Void
    )
}

class ProgramsByFieldsWorker : ProgramsWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetch(
        with params: [Param],
        for universityId: Int,
        completion: @escaping (Result<[GroupOfProgramsModel], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        params.forEach {
            queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        networkService.request(
            endpoint: "/university/\(universityId)/programs/by-field",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[GroupOfProgramsModel], NetworkError>) in
            switch result {
            case .success(let groupsOfPrograms):
                completion(.success(groupsOfPrograms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class ProgramsByFacultiesWorker : ProgramsWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetch(
        with params: [Param],
        for universityId: Int,
        completion: @escaping (Result<[GroupOfProgramsModel], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        params.forEach {
            queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        networkService.request(
            endpoint: "/university/\(universityId)/programs/by-faculty",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[GroupOfProgramsModel], NetworkError>) in
            switch result {
            case .success(let groupsOfPrograms):
                completion(.success(groupsOfPrograms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
