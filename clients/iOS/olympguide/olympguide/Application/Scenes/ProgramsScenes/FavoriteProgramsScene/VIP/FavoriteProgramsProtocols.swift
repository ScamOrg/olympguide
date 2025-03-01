//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

// MARK: - Business Logic
protocol FavoriteProgramsBusinessLogic {
    func loadPrograms(with request: FavoritePrograms.Load.Request)
    func handleBatchError(programID: Int)
    func handleBatchSuccess(programID: Int, isFavorite: Bool)
    func dislikeProgram(at index: Int)
    func likeProgram(_ program: ProgramModel, at insertIndex: Int)
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
    func routeToProgram(with index: Int)
}

// MARK: - Data Passing
protocol FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore? { get }
}
