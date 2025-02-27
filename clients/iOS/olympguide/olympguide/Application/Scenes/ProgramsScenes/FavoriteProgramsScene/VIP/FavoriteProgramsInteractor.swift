//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

final class FavoriteProgramsInteractor: FavoriteProgramsBusinessLogic {
    var presenter: FavoriteProgramsPresentationLogic?
    var worker: WorkerLogic = Worker()
    
    func action(with request: FavoriteProgramsModels.Action.Request) {
        
    }
}

