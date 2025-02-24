//
//  DirectionsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
final class ProgramInteractor: ProgramsBusinessLogic, ProgramsDataStore {
    var groupsOfProgramsByFieldModel: [GroupOfProgramsByFieldModel] = []
    var presenter: ProgramsPresentationLogic?
    var worker: ProgramsWorkerLogic = ProgramsWorker()
    
    func loadPrograms(with request: Programs.Load.Request) {
        worker.fetch(
            with: request.params,
            for: request.universityID
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                let response = Programs.Load.Response(groupsOfPrograms: programs, error: nil)
                self?.presenter?.presentLoadPrograms(with: response)
            case .failure(let error):
                let response = Programs.Load.Response(groupsOfPrograms: nil, error: error)
                self?.presenter?.presentLoadPrograms(with: response)
            }
        }
    }
}

