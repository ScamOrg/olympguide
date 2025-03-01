//
//  UniversityInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

final class UniversityInteractor: UniversityDataStore, ProgramsDataStore {
    var groupsOfPrograms: [GroupOfProgramsModel] = []
    var university: UniversityModel?
    
    var universityID: Int?
    
    var presenter: (UniversityPresentationLogic & ProgramsPresentationLogic)?
    
    var worker = UniversityWorker()
}

extension UniversityInteractor : UniversityBusinessLogic {
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
            case .success:
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
    
extension UniversityInteractor : ProgramsBusinessLogic {
    func loadPrograms(with request: Programs.Load.Request) {
        guard let university = request.university else {return}
        worker.loadPrograms(
            with: request.params,
            for: university.universityID,
            by: request.groups
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                self?.groupsOfPrograms = programs
                let response = Programs.Load.Response(groupsOfPrograms: programs, error: nil)
                self?.presenter?.presentLoadPrograms(with: response)
            case .failure(let error):
                let response = Programs.Load.Response(groupsOfPrograms: nil, error: error)
                self?.presenter?.presentLoadPrograms(with: response)
            }
        }
    }
    
    func restoreFavorite(at indexPath: IndexPath) -> Bool {
        groupsOfPrograms[indexPath.section].programs[indexPath.row].like 
    }
    
    func setFavorite(at indexPath: IndexPath, isFavorite: Bool) {
        groupsOfPrograms[indexPath.section].programs[indexPath.row].like  = isFavorite
    }
}
