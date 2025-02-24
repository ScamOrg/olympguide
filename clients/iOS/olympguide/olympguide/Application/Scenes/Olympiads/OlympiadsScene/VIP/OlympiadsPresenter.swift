//
//  OlympiadsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit

final class OlympiadsPresenter: OlympiadsPresentationLogic {
    
    weak var viewController: OlympiadsDisplayLogic?

    func presentOlympiads(_ response: Olympiads.Load.Response) {
        
        let viewModels = response.olympiads.map { olympiad in
            Olympiads.Load.ViewModel.OlympiadViewModel(
                name: olympiad.name,
                profile: olympiad.profile,
                level: String(repeating: "I", count: olympiad.level)
            )
        }
        
        let viewModel = Olympiads.Load.ViewModel(olympiads: viewModels)
        viewController?.displayOlympiads(viewModel)
    }

    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
