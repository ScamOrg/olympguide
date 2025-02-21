//
//  UniversitiesProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

protocol UniversitiesBusinessLogic {
    func loadUniversities(_ request: Universities.Load.Request)
}

protocol UniversitiesPresentationLogic {
    func presentUniversities(response: Universities.Load.Response)
    func presentError(message: String)
}

protocol UniversitiesDisplayLogic: AnyObject {
    func displayUniversities(viewModel: Universities.Load.ViewModel)
    func displayError(message: String)
}

protocol UniversitiesRoutingLogic {
    func routeToDetails(for university: UniversityModel)
    func routeToSearch()
}

protocol UniversitiesDataStore {
    var universities: [UniversityModel] { get set }
}
