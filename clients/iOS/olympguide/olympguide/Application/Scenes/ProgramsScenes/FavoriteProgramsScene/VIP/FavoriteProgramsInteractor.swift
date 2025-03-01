//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

final class FavoriteProgramsInteractor: FavoriteProgramsBusinessLogic, FavoriteProgramsDataStore {
    var programs: [ProgramModel] = []
    var removePrograms: [Int: ProgramModel] = [:]
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
    
    func likeProgram(_ program: ProgramModel, at insertIndex: Int) {
        programs.insert(program, at: insertIndex)
        removePrograms[program.programID] = nil
    }
    
    func dislikeProgram(at index: Int) {
        let program = programs[index]
        removePrograms[program.programID] = program
        programs.remove(at: index)
    }
    
    func handleBatchError(programID: Int) {
        if let program = removePrograms[programID] {
            let insertIndex = programs.firstIndex { $0.programID > program.programID } ?? self.programs.count
            programs.insert(program, at: insertIndex)
        } else {
            if let index = programs.firstIndex(where: { $0.programID == programID }) {
                programs.remove(at: index)
            }
        }
        
        let response = FavoritePrograms.Load.Response(programs: programs)
        presenter?.presentLoadPrograms(with: response)
    }
    
    func handleBatchSuccess(programID: Int, isFavorite: Bool) {
        if !isFavorite {
            removePrograms[programID] = nil
        }
    }
    
    func restoreFavorite(at index: Int) -> Bool {
        programs[index].like
    }
}

