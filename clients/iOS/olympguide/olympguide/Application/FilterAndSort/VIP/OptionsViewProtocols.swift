//
//  OptionsViewProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

import UIKit

// MARK: - DataStore
protocol OptionsDataStore {
    var options: [DynamicOption] { get set }
}

// MARK: - ViewController → Interactor
protocol OptionsBusinessLogic {
    func textDidChange(request: Options.TextDidChange.Request)
    func loadOptions(request: Options.FetchOptions.Request)
}

// MARK: - Presenter → ViewController
protocol OptionsDisplayLogic: UIViewController {
    func displayTextDidChange(viewModel: Options.TextDidChange.ViewModel)
    func displayFetchOptions(viewModel: Options.FetchOptions.ViewModel)
}

// MARK: - Interactor → Presenter
protocol OptionsPresentationLogic {
    func presentTextDidChange(response: Options.TextDidChange.Response)
    func presentFetchOptions(response: Options.FetchOptions.Response)
    func presentError(message: String)
}
