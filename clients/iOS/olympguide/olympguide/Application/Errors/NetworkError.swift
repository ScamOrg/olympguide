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
    case uniqueViolation(message: String?)
    case userNotFound(message: String?)
    case invalidPassword(message: String?)
    
    init?(serverType: String, time: Int? = nil, message: String? = nil) {
        switch serverType {
        case "PreviousCodeNotExpired":
            if let time = time {
                self = .previousCodeNotExpired(time: time)
            } else {
                self = .unknown(message: "PreviousCodeNotExpired without time")
            }
        case "InternalServerError":
            self = .internalServerError(message: message)
        case "UniqueViolation":
            self = .uniqueViolation(message: message)
        case "UserNotFound":
            self = .userNotFound(message: message)
        case "InvalidPassword":
            self = .invalidPassword(message: message)
        default:
            self = .serverError(message: message)
        }
    }
    
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
        case .uniqueViolation(message: _):
            return "Пользователь с такой почтой уже существует"
        case .userNotFound(message: _):
            return "Пользователь с такой почтой не найден"
        case .invalidPassword(message: _):
            return "Неверный пароль"
        }
    }
}
