//
//  DirectionsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

enum Groups {
    case fields
    case faculties
    
    var endpoint: String {
        switch self {
        case .fields:
            return "by-field"
        case .faculties:
            return "by-faculty"
        }
    }
}

import Foundation
protocol ProgramsWorkerLogic {
    func loadPrograms(
        with params: [Param],
        for universityId: Int,
        by groups: Groups,
        completion: @escaping (Result<[GroupOfProgramsModel], Error>) -> Void
    )
}

class ProgramsByFieldsWorker : ProgramsWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadPrograms(
        with params: [Param],
        for universityId: Int,
        by groups: Groups,
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
    
    func loadPrograms(
        with params: [Param],
        for universityId: Int,
        by groups: Groups,
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
