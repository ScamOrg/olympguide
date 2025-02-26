//
//  DirectionsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
final class ProgramInteractor: ProgramsBusinessLogic, ProgramsDataStore {
    var groupsOfPrograms: [GroupOfProgramsModel]?
    var presenter: ProgramsPresentationLogic?
    var worker: ProgramsWorkerLogic?
    var university: UniversityModel?
    
    func loadPrograms(with request: Programs.Load.Request) {
        guard let university = request.university else {return}
        self.university = request.university
        worker?.loadPrograms(
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
}

