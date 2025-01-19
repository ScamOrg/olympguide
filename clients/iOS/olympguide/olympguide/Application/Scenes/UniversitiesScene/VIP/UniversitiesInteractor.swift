//
//  UniversitiesInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Universitiesnteractor
final class UniversitiesInteractor: UniversitiesBusinessLogic, UniversitiesDataStore {
    var presenter: UniversitiesPresentationLogic?
    var worker: UniversitiesWorker = UniversitiesWorker()
    var universities: [UniversityModel] = []

    func loadUniversities(_ request: Universities.Load.Request) {
        worker.fetchUniversities(regionID: request.regionID, sort: request.sortOption?.rawValue, search: request.searchQuery) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities
                let response = Universities.Load.Response(universities: universities)
                self?.presenter?.presentUniversities(response: response)
            case .failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
}
