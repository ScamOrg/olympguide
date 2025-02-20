//
//  OlimpiadsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation

protocol OlympiadsBusinessLogic {
    func loadOlympiads(_ request: Olympiads.Load.Request)
}

protocol OlympiadsPresentationLogic {
    func presentOlympiads(response: Olympiads.Load.Response)
    func presentError(message: String)
}

protocol OlympiadsDisplayLogic: AnyObject {
    func displayOlympiads(viewModel: Olympiads.Load.ViewModel)
    func displayError(message: String)
}

protocol OlympiadsRoutingLogic {
    func routeToDetails(for university: OlympiadModel)
    func routeToSearch()
}

protocol OlympiadsDataStore {
    var olympiads: [OlympiadModel] { get set }
}
