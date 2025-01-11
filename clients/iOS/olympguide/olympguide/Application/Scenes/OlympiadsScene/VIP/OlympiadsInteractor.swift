//
//  OlympiadsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

// MARK: - Olympiadsnteractor
final class OlympiadsInteractor: OlympiadsBusinessLogic, OlympiadsDataStore {
    var presenter: OlympiadsPresentationLogic?
    var worker: OlympiadsWorker = OlympiadsWorker()
    var olympiads: [OlympiadModel] = []

    func loadOlympiads(_ request: Olympiads.Load.Request) {
        worker.fetchOlympiads(levels: request.levels, sort: request.sortOption?.rawValue, search: request.searchQuery) { [weak self] result in
            switch result {
            case .success(let olympiads):
                self?.olympiads = olympiads
                let response = Olympiads.Load.Response(olympiads: olympiads)
                self?.presenter?.presentOlympiads(response: response)
            case .failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
}
