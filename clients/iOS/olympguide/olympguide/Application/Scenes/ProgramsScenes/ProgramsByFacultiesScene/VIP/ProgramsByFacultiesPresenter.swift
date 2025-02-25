//
//  DirectionsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import UIKit

final class ProgramsByFacultiesPresenter : ProgramsByFacultiesPresentationLogic {
    weak var viewController: (ProgramsByFacultiesDisplayLogic & UIViewController)?
    
    func presentLoadPrograms(with response: ProgramsByFaculties.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        if let groupsOfPrograms = response.groupsOfPrograms {
            let groupsOfProgramsViewModel = groupsOfPrograms.map { groupOfPrograms in
                ProgramsByFaculties.Load.ViewModel.GroupOfProgramsViewModel(
                    name: groupOfPrograms.name,
                    programs: groupOfPrograms.programs.map { program in
                        ProgramViewModel(
                            name: program.name,
                            code: program.field,
                            budgetPlaces: program.budgetPlaces,
                            paidPlaces: program.paidPlaces,
                            cost: program.cost,
                            requiredSubjects: program.requiredSubjects,
                            optionalSubjects: program.optionalSubjects
                        )
                    }
                )
            }
            let viewModel = ProgramsByFaculties.Load.ViewModel(groupsOfPrograms: groupsOfProgramsViewModel)
            viewController?.displayLoadProgramsResult(with: viewModel)
        }
    }
}
