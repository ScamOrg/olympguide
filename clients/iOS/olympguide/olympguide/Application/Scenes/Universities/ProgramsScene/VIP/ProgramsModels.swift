//
//  DirectionsModels.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

enum Programs {
    enum Load {
        struct Request {
        }
        
        struct Response {
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
                
                let fields: [ProgramViewModel]
            }
            
            let groupsOfPrograms: [GroupOfProgramsViewModel]
        }
    }
}

struct Model : Codable {
    //    let olympiadID: Int
    //    enum CodingKeys: String, CodingKey {
    //        case olympiadID = "olympiad_id"
    //        case name, profile, level, like
    //    }
}
