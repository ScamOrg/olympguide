//
//  UniversityInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

final class UniversityInteractor: UniversityBusinessLogic, UniversityDataStore {
    var universityID: Int?
    
    var presenter: UniversityPresentationLogic?
    
    var worker: UniversityWorkerLogic = UniversityWorker()
    
    func loadUniversity(with request: University.Load.Request) {
        universityID = request.universityID
        worker.fetchUniverity(
            with: request.universityID
        ) { [weak self] result in
            switch result {
            case .success(let university):
                let response = University.Load.Response(
                    error: nil,
                    site: university.site,
                    email: university.email
                )
                self?.presenter?.presentLoadUniversity(with: response)
            case .failure(let error):
                let response = University.Load.Response(
                    error: error,
                    site: nil,
                    email: nil
                )
                self?.presenter?.presentLoadUniversity(with: response)
            }
        }
    }
    
    func toggleFavorite(with request: University.Favorite.Request) {
        worker.toggleFavorite(
            with: request.universityID,
            isFavorite: request.isFavorite
        ) { [weak self] result in
            switch result {
            case .success(let university):
                let response = University.Favorite.Response(
                    error: nil
                )
                self?.presenter?.presentToggleFavorite(with: response)
            case .failure(let error):
                let response = University.Favorite.Response(
                    error: error
                )
                self?.presenter?.presentToggleFavorite(with: response)
            }
        }
    }
}
