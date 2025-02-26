//
//  DirectionsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
import UIKit

final class ProgramsRouter: ProgramsRoutingLogic, ProgramsDataPassing {
    var programsDataStore: ProgramsDataStore?
    weak var viewController: UIViewController?
    
    func routeToProgram(with indexPath: IndexPath) {
        guard
            let university = programsDataStore?.university,
            let groupsOfPrograms = programsDataStore?.groupsOfPrograms
        else { return }
        
        let program = groupsOfPrograms[indexPath.section].programs[indexPath.row]
        
        let programVC = ProgramAssembly.build(
            for: program,
            by: university
        )
        
        viewController?.navigationController?.pushViewController(programVC, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchViewController(searchType: .fields)
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}

