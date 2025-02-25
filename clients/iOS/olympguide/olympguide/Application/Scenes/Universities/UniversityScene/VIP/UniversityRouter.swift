//
//  UniversityRouter.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

import UIKit

final class UniversityRouter: UniversityRoutingLogic, UniversityDataPassing {
    var dataStore: UniversityDataStore?
    weak var viewController: UIViewController?
    
    func routeToProgramsByFields(for university: UniversityModel) {
        let programsByFieldsVC = ProgramsByFieldsAssembly.build(for: university)
        viewController?.navigationController?.pushViewController(programsByFieldsVC, animated: true)
    }
    
    func routeToProgramsByFaculties(for university: UniversityModel) {
        let programsByFacultiesVC = ProgramsByFacultiesAssembly.build(for: university)
        viewController?.navigationController?.pushViewController(programsByFacultiesVC, animated: true)
    }
}

