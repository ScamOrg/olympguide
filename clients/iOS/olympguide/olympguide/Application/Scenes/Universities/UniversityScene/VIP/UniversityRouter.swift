//
//  UniversityRouter.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

import UIKit

final class UniversityRouter: UniversityDataPassing, ProgramsDataPassing {
    var dataStore: (UniversityDataStore & ProgramsDataStore)?
    
    var universityDataStore: UniversityDataStore? {
        get { dataStore }
        set { dataStore = newValue as? (UniversityDataStore & ProgramsDataStore) }
    }
    
    var programsDataStore: ProgramsDataStore? {
        get { dataStore }
        set { dataStore = newValue as? (UniversityDataStore & ProgramsDataStore) }
    }
    
    weak var viewController: UIViewController?
}

extension UniversityRouter: UniversityRoutingLogic {
    func routeToProgramsByFields(for university: UniversityModel) {
        let programsByFieldsVC = ProgramsByFieldsAssembly.build(for: university)
        viewController?.navigationController?.pushViewController(programsByFieldsVC, animated: true)
    }
    
    func routeToProgramsByFaculties(for university: UniversityModel) {
        let programsByFacultiesVC = ProgramsByFacultiesAssembly.build(for: university)
        viewController?.navigationController?.pushViewController(programsByFacultiesVC, animated: true)
    }
}

extension UniversityRouter: ProgramsRoutingLogic {
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

