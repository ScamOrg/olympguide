//
//  BenefitsModels.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
enum Benefits {
    enum Load {
        struct Request {
            let programID: Int
            var params: [Param] = []
        }
        
        struct Response {
            var error: Error? = nil
            var olympiads: [OlympiadWithBenefitsModel]? = nil
        }
        
        struct ViewModel {
            struct BenefitViewModel {
                let olympiadName: String
                let olympiadLevel: Int
                let olympiadProfile: String
                let minClass: Int
                let minDiplomaLevel: Int
                let isBVI: Bool
                
                let confirmationSubjects: [OlympiadWithBenefitsModel.Benefit.ConfirmationSubject]?
                let fullScoreSubjects: [String]?
            }
            
            let benefits: [BenefitViewModel]
        }
    }
}

struct OlympiadWithBenefitsModel : Codable {
    struct Olympiad : Codable {
        let olympiadID: Int
        let name: String
        let level: Int
        let profile: String
        
        enum CodingKeys: String, CodingKey {
            case olympiadID = "olympiad_id"
            case name, profile, level
        }
    }
    
    struct Benefit : Codable {
        struct ConfirmationSubject : Codable {
            let subject: String
            let score: Int
        }
        
        let minClass: Int
        let minDiplomaLevel: Int
        let isBVI: Bool
        let confirmationSubjects: [ConfirmationSubject]?
        let fullScoreSubjects: [String]?
        
        enum CodingKeys: String, CodingKey {
            case minClass = "min_class"
            case minDiplomaLevel = "min_diploma_level"
            case isBVI = "is_bvi"
            case confirmationSubjects = "confirmation_subjects"
            case fullScoreSubjects = "full_score_subjects"
        }
    }
    
    let olympiad: Olympiad
    let benefits: [Benefit]
}
