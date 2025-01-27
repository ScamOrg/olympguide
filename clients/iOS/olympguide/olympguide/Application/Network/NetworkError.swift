//
//  NetworkError.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(message: String?)
    case previousCodeNotExpired(time: Int)
    case unknown(message: String?)
    case internalServerError(message: String?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data from server"
        case .decodingError:
            return "Error while decoding server response"
        case .serverError(let message):
            return message ?? "Unknown server error"
        case .previousCodeNotExpired:
            // Если хотим, чтобы в описании писалось время
            return "Previous code is still valid"
        case .unknown(let message):
            return message
        case .internalServerError(message: let message):
            return message
        }
    }
}
