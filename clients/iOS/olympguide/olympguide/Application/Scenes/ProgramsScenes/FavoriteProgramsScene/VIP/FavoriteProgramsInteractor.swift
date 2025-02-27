//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

final class FavoriteProgramsInteractor: FavoriteProgramsBusinessLogic, FavoriteProgramsDataStore {
    var programs: [ProgramModel] = []
    var presenter: FavoriteProgramsPresentationLogic?
    var worker: FavoriteProgramsWorkerLogic?
    
    
    func loadPrograms(with request: FavoritePrograms.Load.Request) {
        worker?.fetchPrograms() { [weak self] result in
            switch result {
            case .success(let programs):
                self?.programs = programs
                self?.presenter?.presentLoadPrograms(with: FavoritePrograms.Load.Response(programs: programs))
            case .failure(let error):
                self?.presenter?.presentLoadPrograms(with: FavoritePrograms.Load.Response(error: error))
            }
        }
    }
}

