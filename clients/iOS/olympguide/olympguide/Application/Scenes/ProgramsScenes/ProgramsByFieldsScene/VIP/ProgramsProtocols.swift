//
//  DirectionsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation

// MARK: - Business Logic
protocol ProgramsBusinessLogic {
    func loadPrograms(with request: Programs.Load.Request)
}

// MARK: - Data Store
protocol ProgramsDataStore {
    var groupsOfProgramsByFieldModel: [GroupOfProgramsModel] { get }
}

// MARK: - Presentation Logic
protocol ProgramsPresentationLogic {
    func presentLoadPrograms(with response: Programs.Load.Response)
}

// MARK: - Display Logic
protocol ProgramsDisplayLogic: AnyObject {
    func displayLoadProgramsResult(with viewModel: Programs.Load.ViewModel)
}

// MARK: - Routing Logic
protocol ProgramsRoutingLogic {
    func routeToProgram()
    func routeToSearch()
}

// MARK: - Data Passing
protocol ProgramsDataPassing {
    var dataStore: ProgramsDataStore? { get }
}
