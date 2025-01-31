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
        let vm = Options.TextDidChange.ViewModel(options: response.options)
        viewController?.displayTextDidChange(viewModel: vm)
    }
}
