//
//  DirectionsModels.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

enum ProgramsByFaculties {
    enum Load {
        struct Request {
            let params: [Param]
            let universityID: Int
        }
        
        struct Response {
            let groupsOfPrograms: [GroupOfProgramsByFacultyModel]?
            let error: Error?
        }
        
        struct ViewModel {
            struct GroupOfProgramsViewModel {
                let name: String
                var isExpanded: Bool = false
                
                let programs: [ProgramViewModel]
            }
            
            let groupsOfPrograms: [GroupOfProgramsViewModel]
        }
    }
}

struct GroupOfProgramsByFacultyModel : Codable {
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
    
    let facultyID: Int
    let name: String
    let programs: [ProgramModel]
    
    enum CodingKeys: String, CodingKey {
        case facultyID = "faculty_id"
        case name, programs
    }
}

struct ProgramViewModel {
    let name: String
    let code: String
    let budgetPlaces: Int
    let paidPlaces: Int
    let cost: Int
    let requiredSubjects: [String]
    let optionalSubjects: [String]?
}
