//
//  ValidationError.swift
//  olympguide
//
//  Created by Tom Tim on 10.02.2025.
//

import Foundation

enum ValidationError: LocalizedError {
    case invalidEmail
    case weakPassword
    case invalidLastName
    case invalidFirstName
    case invalidSecondName
    case invalidBirthay
    case invalidRegion
    
    case emptyField(fieldName: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Неверный формат email"
        case .weakPassword:
            return "Пароль слишком слабый"
        case .emptyField(let fieldName):
            return "Поле \"\(fieldName)\" не может быть пустым"
        default:
            return nil
        }
    }
}
