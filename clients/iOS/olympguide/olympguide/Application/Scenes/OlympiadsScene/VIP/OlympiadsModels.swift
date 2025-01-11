//
//  OlympiadsModels.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

// MARK: - Main screen: Olympiads
enum Olympiads {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let sortOption: SortOption?
            let searchQuery: String?
            let levels: [Int]?
            let profiles: [String]?
        }
        
        struct Response {
            let olympiads: [OlympiadModel]
        }
        
        struct ViewModel {
            struct OlympiadViewModel {
                let name: String
                let profile: String
                let level: String
            }
            
            let olympiads: [OlympiadViewModel]
        }
    }
    
    // MARK: - Sorting options
    enum SortOption: String {
        case name
        case popularity
        case level
    }
}


struct OlympiadModel: Codable {
    let olympiadID: Int
    let name: String
    let profile: String
    let level: Int
    let popularity: Int

    enum CodingKeys: String, CodingKey {
        case olympiadID = "olympiad_id"
        case name, profile, level, popularity
    }
}
