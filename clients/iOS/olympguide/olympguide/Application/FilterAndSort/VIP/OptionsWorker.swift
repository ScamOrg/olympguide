//
//  OptionsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

final class OptionsWorker {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func filter(
        items: [DynamicOption],
        with query: String
    ) -> [Options.TextDidChange.Response.Dependencies] {
        var result: [Options.TextDidChange.Response.Dependencies] = []
        var currentIndex: Int = 0
        for (index, item) in items.enumerated() {
            guard item.name
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .contains(query.lowercased()) || query.isEmpty
            else{ continue }
            result.append(Options.TextDidChange.Response.Dependencies(realIndex: index, currentIndex: currentIndex))
            currentIndex += 1
        }
        
        return result 
    }
    
    func fetchOptions(
        endPoint: String,
        completion: @escaping (Result<[DynamicOption], Error>) -> Void
    ) {
        networkService.request(
            endpoint: endPoint,
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<[DynamicOption], NetworkError>) in
            switch result {
            case .success(let options):
                completion(.success(options))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
