//
//  DirectionsModels.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

enum Programs {
    enum Load {
        struct Request {
            let params: [Param]
            let universityID: Int
        }
        
        struct Response {
            let groupsOfPrograms: [GroupOfProgramsByFieldModel]?
            let error: Error?
        }
        
        struct ViewModel {
            struct GroupOfProgramsViewModel {
                struct ProgramViewModel {
                    let name: String
                    let code: String
                    let budgetPlaces: String
                    let paidPlaces: String
                    let cost: String
                    let requiredSubjects: [String]
                    let optionalSubjects: [String]?
                }
                
                let name: String
                let code: String
                var isExpanded: Bool = false
                
                let programs: [ProgramViewModel]
            }
            
            let groupsOfPrograms: [GroupOfProgramsViewModel]
        }
    }
}

struct GroupOfProgramsByFieldModel : Codable {
    struct ProgramModel : Codable {
        let programID: Int
        let name: String
        let field: String
        let budgetPlaces: Int
        let paidPlaces: Int
        let cost: Int
        let requiredSubjects: [String]
        let optionalSubjects: [String]?
        let like: Bool
        
        enum CodingKeys: String, CodingKey {
            case programID = "program_id"
            case budgetPlaces = "budget_places"
            case paidPlaces = "paid_places"
            case name, field, cost, like
            case requiredSubjects = "required_subjects"
            case optionalSubjects = "optional_subjects"
        }
    }
    
    let groupID: Int
    let name: String
    let code: String
    let programs: [ProgramModel]
    
    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case name, code, programs
    }
}
