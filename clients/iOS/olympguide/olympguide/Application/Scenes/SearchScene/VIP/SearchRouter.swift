//
//  SearchRouter.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//


import UIKit

final class SearchRouter: SearchRoutingLogic, SearchDataPassing {
    
    weak var viewController: UIViewController?
    var dataStore: SearchDataStore?
    
    func routeToSomeNextScene(selected: String) {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
