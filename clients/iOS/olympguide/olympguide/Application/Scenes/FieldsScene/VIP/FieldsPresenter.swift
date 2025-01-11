//
//  FieldsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class FieldsPresenter: FieldsPresentationLogic {
    
    weak var viewController: FieldsDisplayLogic?
    
    func presentFields(response: Fields.Load.Response) {
        let viewModels = response.groupsOfFields.map { groupOfFields in
            Fields.Load.ViewModel.GroupOfFieldsViewModel(
                name: groupOfFields.name,
                code: groupOfFields.code,
                fields: groupOfFields.fields.map { field in
                    Fields.Load.ViewModel.GroupOfFieldsViewModel.FieldViewModel(
                        name: field.name,
                        code: field.code
                    )
                }
            )
        }
        
        let viewModel = Fields.Load.ViewModel(groupsOfFields: viewModels)
        viewController?.displayFields(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
