//
//  BenefitsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
// MARK: - Business Logic
protocol BenefitsBusinessLogic {
    func loadBenefits(with request: Benefits.Load.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol BenefitsDataStore {
    
}

// MARK: - Presentation Logic
protocol BenefitsPresentationLogic {
    func presentLoadBenefits(with response: Benefits.Load.Response)
}

// MARK: - Display Logic
protocol BenefitsDisplayLogic: AnyObject {
    func displayLoadBenefitsResult(with viewModel: Benefits.Load.ViewModel)
}

// MARK: - Routing Logic
protocol BenefitsRoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol BenefitsDataPassing {
    var dataStore: BenefitsDataStore? { get }
}

protocol BenefitsWorkerLogic {
    func fetchBenefits(
        for progrmaId: Int,
        with params: [Param],
        completion: @escaping (Result<[OlympiadWithBenefitsModel]?, Error>) -> Void
    )
}
