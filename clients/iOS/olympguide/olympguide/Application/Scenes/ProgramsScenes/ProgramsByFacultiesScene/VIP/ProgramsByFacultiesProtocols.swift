//
//  DirectionsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation

// MARK: - Business Logic
protocol ProgramsByFacultiesBusinessLogic {
    func loadPrograms(with request: Programs.Load.Request)
}

// MARK: - Data Store
protocol ProgramsByFacultiesDataStore {
    var groupsOfProgramsByFieldModel: [GroupOfProgramsByFacultyModel] { get }
}

// MARK: - Presentation Logic
protocol ProgramsByFacultiesPresentationLogic {
    func presentLoadPrograms(with response: ProgramsByFaculties.Load.Response)
}

// MARK: - Display Logic
protocol ProgramsByFacultiesDisplayLogic: AnyObject {
    func displayLoadProgramsResult(with viewModel: ProgramsByFaculties.Load.ViewModel)
}

// MARK: - Routing Logic
protocol ProgramsByFacultiesRoutingLogic {
    func routeToProgram()
    func routeToSearch()
}

// MARK: - Data Passing
protocol ProgramsByFacultiesDataPassing {
    var dataStore: ProgramsByFacultiesDataStore? { get }
}
