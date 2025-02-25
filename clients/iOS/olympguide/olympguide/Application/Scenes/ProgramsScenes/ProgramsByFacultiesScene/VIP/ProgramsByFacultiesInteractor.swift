//
//  DirectionsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
final class ProgramsByFacultiesInteractor: ProgramsByFacultiesBusinessLogic, ProgramsByFacultiesDataStore {
    var groupsOfProgramsByFieldModel: [GroupOfProgramsByFacultyModel] = []
    var presenter: ProgramsByFacultiesPresentationLogic?
    var worker: ProgramsByFacultiesWorkerLogic = ProgramsByFacultiesWorker()
    
    func loadPrograms(with request: Programs.Load.Request) {
        worker.fetch(
            with: request.params,
            for: request.universityID
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                let response = ProgramsByFaculties.Load.Response(groupsOfPrograms: programs, error: nil)
                self?.presenter?.presentLoadPrograms(with: response)
            case .failure(let error):
                let response = ProgramsByFaculties.Load.Response(groupsOfPrograms: nil, error: error)
                self?.presenter?.presentLoadPrograms(with: response)
            }
        }
    }
}

