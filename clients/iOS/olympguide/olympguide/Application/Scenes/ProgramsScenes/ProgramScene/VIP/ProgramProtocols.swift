//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation

// MARK: - Business Logic
protocol ProgramBusinessLogic {
    func loadProgram(with request: Program.Load.Request)
    func toggleFavorite(request: Program.Favorite.Request)
}

// MARK: - Data Store
protocol ProgramDataStore {
    
}

// MARK: - Presentation Logic
protocol ProgramPresentationLogic {
    func presentLoadProgram(with response: Program.Load.Response)
    func presentToggleFavorite(response: Program.Favorite.Response)
}

// MARK: - Display Logic
protocol ProgramDisplayLogic: AnyObject {
    func displayLoadProgram(with viewModel: Program.Load.ViewModel)
    func displayToggleFavoriteResult(viewModel: Program.Favorite.ViewModel)
}

// MARK: - Routing Logic
protocol ProgramRoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol ProgramDataPassing {
    var dataStore: ProgramDataStore? { get }
}
