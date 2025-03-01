//
//  Presenter.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteProgramsPresenter : FavoriteProgramsPresentationLogic {
    weak var viewController: (FavoriteProgramsDisplayLogic & UIViewController)?
    
    func presentLoadPrograms(with response: FavoritePrograms.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
        }
        
        guard let programs = response.programs else { return }
        
        let viewPrograms  = programs.map { program in
            ProgramViewModel(
                programID: program.programID,
                name: program.name,
                code: program.field,
                budgetPlaces: program.budgetPlaces,
                paidPlaces: program.paidPlaces,
                cost: program.cost,
                like: program.like,
                requiredSubjects: program.requiredSubjects,
                optionalSubjects: program.optionalSubjects
            )
        }
        
        let viewModel = FavoritePrograms.Load.ViewModel(programs: viewPrograms)
        viewController?.displayLoadProgramsResult(with: viewModel)
    }
}
