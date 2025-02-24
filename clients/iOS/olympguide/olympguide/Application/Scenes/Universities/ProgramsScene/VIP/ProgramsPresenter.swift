//
//  DirectionsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import UIKit

final class ProgramPresenter : ProgramsPresentationLogic {
    weak var viewController: (ProgramsDisplayLogic & UIViewController)?
    
    func presentLoadPrograms(with response: Programs.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        if let groupsOfPrograms = response.groupsOfPrograms {
            let groupsOfProgramsViewModel = groupsOfPrograms.map { groupOfPrograms in
                Programs.Load.ViewModel.GroupOfProgramsViewModel(
                    name: groupOfPrograms.name,
                    code: groupOfPrograms.code,
                    programs: groupOfPrograms.programs.map { program in
                        Programs.Load.ViewModel.GroupOfProgramsViewModel.ProgramViewModel(
                            name: program.name,
                            code: program.field,
                            budgetPlaces: String(program.budgetPlaces),
                            paidPlaces: String(program.paidPlaces),
                            cost: String(program.cost),
                            requiredSubjects: program.requiredSubjects,
                            optionalSubjects: program.optionalSubjects
                        )
                    }
                )
            }
            let viewModel = Programs.Load.ViewModel(groupsOfPrograms: groupsOfProgramsViewModel)
            viewController?.displayLoadProgramsResult(with: viewModel)
        }
    }
}
