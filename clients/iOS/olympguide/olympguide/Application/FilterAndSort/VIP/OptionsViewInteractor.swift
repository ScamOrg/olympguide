//
//  OptionsViewInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

final class OptionsViewInteractor : OptionsDataStore, OptionsBusinessLogic {
    var presenter: OptionsPresentationLogic?
    var items: [OptionModel] = []
    var results: [OptionModel] = []
    
    private let worker = OptionsWorker()
    
    func textDidChange(request: Options.TextDidChange.Request) {
        results = worker.filter(items: items, with: request.query)
        presenter?.presentTextDidChange(response: Options.TextDidChange.Response(options: results))
    }
}
