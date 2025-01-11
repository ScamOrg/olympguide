//
//  SearchProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import UIKit

// MARK: - ViewController → Interactor
protocol SearchBusinessLogic {
    func loadScene(request: Search.Load.Request)
    func textDidChange(request: Search.TextDidChange.Request)
    func selectItem(request: Search.SelectItem.Request)
}

// MARK: - Interactor → Presenter
protocol SearchPresentationLogic {
    func presentLoadScene(response: Search.Load.Response)
    func presentTextDidChange(response: Search.TextDidChange.Response)
    func presentSelectItem(response: Search.SelectItem.Response)
}

// MARK: - Presenter → ViewController
protocol SearchDisplayLogic: AnyObject {
    func displayLoadScene(viewModel: Search.Load.ViewModel)
    func displayTextDidChange(viewModel: Search.TextDidChange.ViewModel)
    func displaySelectItem(viewModel: Search.SelectItem.ViewModel)
}

// MARK: - Router Logic
protocol SearchRoutingLogic {
    func routeToSomeNextScene(selected: String)
}

// MARK: - DataStore
protocol SearchDataStore {
    var searchType: SearchType? { get set }
    var results: [String] { get set }
}

// MARK: - Data Passing
protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get set }
}
