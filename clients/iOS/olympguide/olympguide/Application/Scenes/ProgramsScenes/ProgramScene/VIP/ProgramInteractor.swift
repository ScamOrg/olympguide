//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
final class ProgramInteractor {
    var presenter: (ProgramPresentationLogic & BenefitsPresentationLogic)?
    var worker: (ProgramWorkerLogic & BenefitsWorkerLogic)?
    var olympiads: [OlympiadWithBenefitsModel] = []
}

// MARK: - ProgramBusinessLogic
extension ProgramInteractor : ProgramBusinessLogic {
    func toggleFavorite(request: Program.Favorite.Request) {
        
    }
    
    func loadProgram(with request: Program.Load.Request) {
        worker?.fetchProgram(
            with: request.programID
        ) { [weak self] result in
            switch result {
            case .success(let program):
                let response = Program.Load.Response(program: program)
                self?.presenter?.presentLoadProgram(with: response)
            case .failure(let error):
                let response = Program.Load.Response(error: error)
                self?.presenter?.presentLoadProgram(with: response)
            }
        }
    }
}

// MARK: - BenefitsBusinessLogic
extension ProgramInteractor: BenefitsBusinessLogic {
    func loadBenefits(with request: Benefits.Load.Request) {
        worker?.fetchBenefits(
            for: request.programID,
            with: request.params
        ) { [weak self] result in
            switch result {
            case .success(let olympiads):
                self?.olympiads = olympiads ?? []
                let response = Benefits.Load.Response(olympiads: olympiads)
                self?.presenter?.presentLoadBenefits(with: response)
            case .failure(let error):
                let response = Benefits.Load.Response(error: error)
                self?.presenter?.presentLoadBenefits(with: response)
            }
        }
    }
}

