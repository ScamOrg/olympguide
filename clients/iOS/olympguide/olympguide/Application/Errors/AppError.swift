//
//  AppError.swift
//  olympguide
//
//  Created by Tom Tim on 10.02.2025.
//

import Foundation

enum AppError: LocalizedError {
    case network(NetworkError)
    case validation([ValidationError])

    var errorDescriptions: [String] {
        switch self {
        case .network(let networkError):
            return [networkError.localizedDescription]
        case .validation(let validationErrors):
            return validationErrors.map { $0.localizedDescription }
        }
    }
}
