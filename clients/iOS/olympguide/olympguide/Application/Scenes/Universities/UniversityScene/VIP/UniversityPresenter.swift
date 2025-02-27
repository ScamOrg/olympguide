//
//  UniversityPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit

final class UniversityPresenter : UniversityPresentationLogic {
    weak var viewController: (ProgramsDisplayLogic & UniversityDisplayLogic & UIViewController)?
    
    func presentLoadUniversity(with response: University.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        guard let site = response.site, let email = response.email else {
            return
        }
        let viewModel = University.Load.ViewModel(site: site, email: email)
        viewController?.displayLoadResult(with: viewModel)
    }
    
    func presentToggleFavorite(with response: University.Favorite.Response) {
        if let error = response.error {
            let viewModel = University.Favorite.ViewModel(errorMessage: error.localizedDescription)
            viewController?.displayToggleFavoriteResult(with: viewModel)
        }
    }
}

extension UniversityPresenter : ProgramsPresentationLogic {
    func presentLoadPrograms(with response: Programs.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        if let groupsOfPrograms = response.groupsOfPrograms {
            let groupsOfProgramsViewModel = groupsOfPrograms.map { groupOfPrograms in
                Programs.Load.ViewModel.GroupOfProgramsViewModel(
                    name: groupOfPrograms.name,
                    code: groupOfPrograms.code ?? "",
                    programs: groupOfPrograms.programs.map { program in
                        Programs
                            .Load
                            .ViewModel
                            .GroupOfProgramsViewModel
                            .ProgramViewModel(
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
            let viewModel = Programs.Load.ViewModel(groupsOfPrograms: groupsOfProgramsViewModel)
            viewController?.displayLoadProgramsResult(with: viewModel)
        }
    }
}
