//
//  Worker.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//
import Foundation

protocol ProgramWorkerLogic {
    func fetch(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[OlympiadWithBenefitsModel], Error>) -> Void
    )
    
    func fetchProgram(
        with programId: Int,
        completion: @escaping (Result<ProgramModel, Error>) -> Void
    )
}

final class ProgramWorker : ProgramWorkerLogic {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetch(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[OlympiadWithBenefitsModel], Error>) -> Void
    ) {
//        var queryItems = [URLQueryItem]()
//        
//        networkService.request(
//            endpoint: "",
//            method: .get,
//            queryItems: queryItems,
//            body: nil
//        ) { (result: Result<[OlymiadWithBenefitsModel], NetworkError>) in
//            switch result {
//            case .success(let olympiads):
//                completion(.success(olympiads))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
    
    func fetchProgram(
        with programId: Int,
        completion: @escaping (Result<ProgramModel, Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/program/\(programId)",
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<ProgramModel, NetworkError>) in
            switch result {
            case .success(let program):
                completion(.success(program))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ProgramWorker : BenefitsWorkerLogic {
    func fetchBenefits(
        for progrmaId: Int,
        with params: [Param],
        completion: @escaping (Result<[OlympiadWithBenefitsModel]?, Error>) -> Void
    ) {
        var queryItems: [URLQueryItem] = []
        
        for param in params {
            queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        networkService.request(
            endpoint: "/program/\(progrmaId)/benefits",
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<[OlympiadWithBenefitsModel]?, NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
