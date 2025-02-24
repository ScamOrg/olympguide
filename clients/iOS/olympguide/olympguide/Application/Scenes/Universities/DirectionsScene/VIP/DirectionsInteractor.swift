//
//  DirectionsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
final class Interactor: BusinessLogic {
    var presenter: PresentationLogic?
    var worker: WorkerLogic = Worker()
    
    func fetchDirections(request: Models.Action.Request) {
        
    }
}

