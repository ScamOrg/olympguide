//
//  Program.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
enum Program {
    enum Favorite {
        struct Request {
            let programID: Int
            let isFavorite: Bool
        }
        
        struct Response {
            let error: Error?
        }
        
        struct ViewModel {
            let errorMessage: String?
        }
    }
    
    enum Load {
        struct Request {
            let programID: Int
        }
        
        struct Response {
            var error: Error? = nil
            var program: ProgramModel? = nil
        }
        
        struct ViewModel {
            let link: String
        }
    }
}


struct ProgramModel : Codable {
    struct University: Codable {
        let university_id: Int
        let name: String
        let logo: String
        
        
    }
    
    let programID: Int
    let name: String
    let field: String
    let budgetPlaces: Int
    let paidPlaces: Int
    let cost: Int
    let requiredSubjects: [String]
    let optionalSubjects: [String]
    let like: Bool
    let university: University
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case programID = "program_id"
        case budgetPlaces = "budget_places"
        case paidPlaces = "paid_places"
        case requiredSubjects = "required_subjects"
        case optionalSubjects = "optional_subjects"
        case name, field, cost, like, link, university
    }
}
