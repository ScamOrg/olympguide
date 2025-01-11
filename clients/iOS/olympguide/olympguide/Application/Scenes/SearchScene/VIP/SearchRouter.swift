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
    
    /// Куда перейти после выбора результата
    func routeToSomeNextScene(selected: String) {
        // Например, вы могли бы:
        // 1. Передать selected в DetailsScene
        // 2. Открыть новый экран
        // 3. Или просто закрыть текущий экран
        // Пример — закрыть экран:
        
        // Если это navigationController:
        viewController?.navigationController?.popViewController(animated: true)
        
        // Или dismiss (если презентовали модально)
        // viewController?.dismiss(animated: true)
    }
}
