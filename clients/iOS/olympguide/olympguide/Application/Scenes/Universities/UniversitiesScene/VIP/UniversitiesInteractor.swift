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
    var params: Dictionary<String, Set<String>> = [:]
    func loadUniversities(_ request: Universities.Load.Request) {
        params = request.params
        worker.fetchUniversities(
            with: params
        ) { [weak self] result in
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
