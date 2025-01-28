//
//  FieldWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

class FieldsWorker {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchFields(
        degree: String?,
        search: String?,
        completion: @escaping (Result<[GroupOfFieldsModel], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()

        if let degree = degree {
            queryItems.append(URLQueryItem(name: "sort", value: degree))
        }
        if let search = search {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        networkService.request(
            endpoint: "/fields",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[GroupOfFieldsModel], NetworkError>) in
            switch result {
            case .success(let groupsOfFieldsModel):
                completion(.success(groupsOfFieldsModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
