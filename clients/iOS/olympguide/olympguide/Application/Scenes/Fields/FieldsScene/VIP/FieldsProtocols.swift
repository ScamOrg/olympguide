//
//  FieldsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import Foundation

protocol FieldsBusinessLogic {
    func loadFields(_ request: Fields.Load.Request)
}

protocol FieldsPresentationLogic {
    func presentFields(response: Fields.Load.Response)
    func presentError(message: String)
}

protocol FieldsDisplayLogic: AnyObject {
    func displayFields(viewModel: Fields.Load.ViewModel)
    func displayError(message: String)
}

protocol FieldsRoutingLogic {
    func routeToDetails(for field: GroupOfFieldsModel.FieldModel)
    func routeToSearch()
}

protocol FieldsDataStore {
    var groupsOfFields: [GroupOfFieldsModel] { get set }
}
