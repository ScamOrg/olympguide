//
//  OptionsViewInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

final class OptionsViewInteractor : OptionsDataStore, OptionsBusinessLogic {
    
    var presenter: OptionsPresentationLogic?
    var options: [DynamicOption] = []
    
    private let worker = OptionsWorker()
    
    func textDidChange(request: Options.TextDidChange.Request) {
        let results: [Options.TextDidChange.Response.Dependencies] = worker.filter(items: options, with: request.query)
        
        presenter?.presentTextDidChange(response: Options.TextDidChange.Response(options: results))
    }
    
    func loadOptions(request: Options.FetchOptions.Request) {
        worker.fetchOptions(
            endPoint: request.endPoint
        ) { [weak self] result in
            switch result {
            case .success(let options):
                self?.options = options
                self?.presenter?.presentFetchOptions(response: Options.FetchOptions.Response(options: options))
            case .failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
}
