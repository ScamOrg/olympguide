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
    case passwordWithoutLowercaseLetter
    case passwordWithoutUpperrcaseLetter
    case passwordWithoutDigit
    case invalidLastName
    case invalidFirstName
    case invalidSecondName
    case invalidBirthay
    case invalidRegion
    case shortPassword
    
    case emptyField(fieldName: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Неверный формат email"
        case .weakPassword:
            return "Пароль слишком слабый."
        case .shortPassword:
            return "Пароль должен состоять не менее, чем из 8-ми символов."
        case .passwordWithoutDigit:
            return "Пароль должен содержать не менее одной цифры."
        case .passwordWithoutLowercaseLetter:
            return "Пароль должен содержать не менее одной строчной латинской буквы."
        case .passwordWithoutUpperrcaseLetter:
            return "Пароль должен содержать не менее одной прописной латинской буквы."
        case .invalidLastName:
            return "Заполните фамилию"
        case .invalidFirstName:
            return "Заполните имя"
        case .invalidSecondName:
            return "Заполните отчество"
        case .invalidBirthay:
            return "Заполните дату рождения"
        case .invalidRegion:
            return "Выберите регион"
        case .emptyField(let fieldName):
            return "Поле \"\(fieldName)\" не может быть пустым"
        }
    }
}
