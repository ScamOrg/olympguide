//
//  Param.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

enum Param {
    case level(Int)
    case diplomaClass(Int)
    case region(Int)
    
    init?(_ param_name: String, _ param_value: Any) {
        switch param_name {
            case "level":
            if let value = param_value as? Int {
                self = .level(value)
                return
            }
        case "diploma_class":
            if let value = param_value as? Int {
                self = .diplomaClass(value)
                return
            }
        case "region":
            if let value = param_value as? Int {
                self = .region(value)
                return
            }
        default:
            return nil
        }
        return nil
    }
}
