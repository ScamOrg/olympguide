//
//  UniversitiesPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class UniversitiesPresenter: UniversitiesPresentationLogic {
    
    weak var viewController: UniversitiesDisplayLogic?

    func presentUniversities(response: Universities.Load.Response) {
        let viewModels = response.universities.map { university in
            Universities.Load.ViewModel.UniversityViewModel(
                name: university.name,
                logoURL: university.logo,
                region: university.region,
                popularity: "Popularity: \(university.popularity)"
            )
        }
        
        let viewModel = Universities.Load.ViewModel(universities: viewModels)
        viewController?.displayUniversities(viewModel: viewModel)
    }

    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
