//
//  ProgramAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

final class ProgramAssembly {
    static func build(
        for program: GroupOfProgramsModel.ProgramModel,
        by university: UniversityModel
    ) -> UIViewController {
        let viewContoller = ProgramViewController(for: program, by: university)
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let worker = ProgramWorker()
        
        viewContoller.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewContoller
        
        return viewContoller
    }
    
    static func build(for program: ProgramModel) -> UIViewController {
        let viewContoller = ProgramViewController(for: program)
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let worker = ProgramWorker()
        
        viewContoller.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewContoller
        
        return viewContoller
    }
}
