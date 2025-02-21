//
//  UniversityPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit

final class UniversityPresenter : UniversityPresentationLogic {
    weak var viewController: (UniversityDisplayLogic & UIViewController)?
    
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
}
