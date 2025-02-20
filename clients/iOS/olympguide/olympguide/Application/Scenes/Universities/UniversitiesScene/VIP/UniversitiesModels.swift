//
//  UniversitiesModels.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Main screen: Universities
enum Universities {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let regionID: Int?
            let sortOption: SortOption?
            let searchQuery: String?
        }
        
        struct Response {
            let universities: [UniversityModel]
        }
        
        struct ViewModel {
            struct UniversityViewModel {
                let name: String
                let logoURL: String
                let region: String
                let like: Bool
            }
            
            let universities: [UniversityViewModel]
        }
    }
    
    // MARK: - Sorting options
    enum SortOption: String {
        case name
        case popularity
    }
}


struct UniversityModel: Codable {
    let universityID: Int
    let name: String
    let logo: String
    let region: String
    let like: Bool
    enum CodingKeys: String, CodingKey {
        case universityID = "university_id"
        case name, logo, region, like
    }
}
