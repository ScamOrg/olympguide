//
//  DirectionsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation

enum Groups {
    case fields
    case faculties
    
    var endpoint: String {
        switch self {
        case .fields:
            return "by-field"
        case .faculties:
            return "by-faculty"
        }
    }
}

protocol ProgramsWorkerLogic {
    func loadPrograms(
        with params: [Param],
        for universityId: Int,
        by groups: Groups,
        completion: @escaping (Result<[GroupOfProgramsModel], Error>) -> Void
    )
}
