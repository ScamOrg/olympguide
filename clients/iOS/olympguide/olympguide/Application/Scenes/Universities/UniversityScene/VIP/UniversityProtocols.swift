//
//  UniversityProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

// MARK: - Business Logic
protocol UniversityBusinessLogic {
    func loadUniversity(with request: University.Load.Request)
    func toggleFavorite(with request: University.Favorite.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol UniversityDataStore {
    var universityID: Int? { get }
}

// MARK: - Presentation Logic
protocol UniversityPresentationLogic {
    func presentLoadUniversity(with response: University.Load.Response)
    func presentToggleFavorite(with response: University.Favorite.Response)
}

// MARK: - Display Logic
protocol UniversityDisplayLogic: AnyObject {
    func displayLoadResult(with viewModel: University.Load.ViewModel)
    func displayToggleFavoriteResult(with viewModel: University.Favorite.ViewModel)
}

// MARK: - Routing Logic
protocol UniversityRoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol UniversityDataPassing {
    var dataStore: UniversityDataStore? { get }
}
