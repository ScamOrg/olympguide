//
//  FavoriteUniversitiesWorker.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

final class FavoriteUniversitiesWorker : UniversitiesWorkerLogic {
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
            endpoint: "/user/favourite/universities",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[UniversityModel]?, NetworkError>) in
            switch result {
            case .success(let universities):
                if let universities = universities {
                    let resultUniversities = universities.map { university in
                        var modifiedUniversity = university
                        modifiedUniversity.like = isFavorite(
                            univesityID: university.universityID,
                            serverValue: university.like ?? false
                        )
                        return modifiedUniversity
                    }.filter { $0.like ?? false }
                }
                completion(.success(universities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
        func isFavorite(univesityID: Int, serverValue: Bool) -> Bool {
            FavoritesManager.shared.isUniversityFavorited(
                universityID: univesityID,
                serverValue: serverValue
            )
        }
    }
}
