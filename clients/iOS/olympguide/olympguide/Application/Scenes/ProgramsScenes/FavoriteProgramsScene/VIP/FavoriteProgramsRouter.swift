//
//  Router.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteProgramsRouter: FavoriteProgramsRoutingLogic, FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore?
    weak var viewController: UIViewController?
    
    func routeToProgram(with index: Int) {
        guard let program = dataStore?.programs[index] else { return }
        
        let programVC = ProgramAssembly.build(for: program)
        viewController?.navigationController?.pushViewController(programVC, animated: true)
    }
}

