//
//  DirectionsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
final class ProgramInteractor: BusinessLogic {
    var presenter: PresentationLogic?
    var worker: WorkerLogic = ProgramWorker()
    
    func fetchDirections(request: Programs.Load.Request) {
        
    }
}

