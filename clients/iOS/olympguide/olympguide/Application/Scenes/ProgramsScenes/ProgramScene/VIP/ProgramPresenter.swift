//
//  Presenter.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class ProgramPresenter {
    weak var viewController: (BenefitsDisplayLogic & ProgramDisplayLogic & UIViewController)?
}

extension ProgramPresenter : ProgramPresentationLogic {
    func presentToggleFavorite(response: Program.Favorite.Response) {
        
    }
    
    func presentLoadProgram(with response: Program.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let link = response.program?.link else { return }
        
        let viewModel = Program.Load.ViewModel(link: link)
        viewController?.displayLoadProgram(with: viewModel)
    }
}

extension ProgramPresenter : BenefitsPresentationLogic {
    func presentLoadBenefits(with response: Benefits.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let olympiads = response.olympiads else { return }
        
        let benefits = olympiads.flatMap { model in
            model.benefits.map { benefit in
                Benefits.Load.ViewModel.BenefitViewModel(
                    olympiadName: model.olympiad.name,
                    olympiadLevel: model.olympiad.level,
                    olympiadProfile: model.olympiad.profile,
                    minClass: benefit.minClass,
                    minDiplomaLevel: benefit.minDiplomaLevel,
                    isBVI: benefit.isBVI,
                    confirmationSubjects: benefit.confirmationSubjects,
                    fullScoreSubjects: benefit.fullScoreSubjects
                )
            }
        }
        
        let viewModel = Benefits.Load.ViewModel(benefits: benefits)
        viewController?.displayLoadBenefitsResult(with: viewModel)
    }
}
