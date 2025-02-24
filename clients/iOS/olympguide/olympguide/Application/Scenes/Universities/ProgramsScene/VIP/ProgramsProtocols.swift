//
//  DirectionsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
// MARK: - Business Logic
protocol BusinessLogic {
    func fetchDirections(request: Programs.Load.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol DataStore {
    
}

// MARK: - Presentation Logic
protocol PresentationLogic {
    func presentActioon(response: Programs.Load.Response)
}

// MARK: - Display Logic
protocol DisplayLogic: AnyObject {
    func displayActionResult(viewModel: Programs.Load.ViewModel)
}

// MARK: - Routing Logic
protocol RoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol DataPassing {
    var dataStore: DataStore? { get }
}
