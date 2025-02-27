//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

// MARK: - Business Logic
protocol FavoriteProgramsBusinessLogic {
    func loadPrograms(with request: FavoritePrograms.Load.Request)
}

// MARK: - Data Store
protocol FavoriteProgramsDataStore {
    var programs: [ProgramModel] { get }
}

// MARK: - Presentation Logic
protocol FavoriteProgramsPresentationLogic {
    func presentLoadPrograms(with response: FavoritePrograms.Load.Response)
}

// MARK: - Display Logic
protocol FavoriteProgramsDisplayLogic: AnyObject {
    func displayLoadProgramsResult(with viewModel: FavoritePrograms.Load.ViewModel)
}

// MARK: - Routing Logic
protocol FavoriteProgramsRoutingLogic {
    func routeToProgram()
}

// MARK: - Data Passing
protocol FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore? { get }
}
