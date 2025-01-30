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
    
    func textDidChange(request: Search.TextDidChange.Request) {
        
    }
}
