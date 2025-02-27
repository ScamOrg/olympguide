//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

// MARK: - Business Logic
protocol FavoriteProgramsBusinessLogic {
    func action(with request: FavoriteProgramsModels.Action.Request)
}

// MARK: - Data Store
protocol FavoriteProgramsDataStore {
    
}

// MARK: - Presentation Logic
protocol FavoriteProgramsPresentationLogic {
    func presentActioon(with response: FavoriteProgramsModels.Action.Response)
}

// MARK: - Display Logic
protocol FavoriteProgramsDisplayLogic: AnyObject {
    func displayActionResult(with viewModel: FavoriteProgramsModels.Action.ViewModel)
}

// MARK: - Routing Logic
protocol FavoriteProgramsRoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore? { get }
}
