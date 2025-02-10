//
//  OptionsViewPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

import Foundation

final class OptionViewPresenter : OptionsPresentationLogic {
    weak var viewController: OptionsDisplayLogic?
    
    func presentTextDidChange(response: Options.TextDidChange.Response) {
        let viewModels = response.options.map { option in
            Options.TextDidChange.ViewModel.DependenciesViewModel(
                realIndex: option.realIndex,
                currentIndex: option.currentIndex
            )
        }
        
        let viewModel = Options.TextDidChange.ViewModel(dependencies: viewModels)
        viewController?.displayTextDidChange(viewModel: viewModel)
    }
    
    func presentFetchOptions(response: Options.FetchOptions.Response) {
        let viewModels = response.options.map { option in
            Options.FetchOptions.ViewModel.OptionViewModel(
                id: option.id,
                name: option.name
            )
        }
        
        let viewModel = Options.FetchOptions.ViewModel(options: viewModels)
        viewController?.displayFetchOptions(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.showAlert(with: message)
    }
}
