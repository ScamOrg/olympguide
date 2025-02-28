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
            let params: Dictionary<String, Set<String>>
        }
        
        struct Response {
            let universities: [UniversityModel]
        }
        
        struct ViewModel {
            struct UniversityViewModel {
                let universityID: Int
                let name: String
                let logoURL: String
                let region: String
                var like: Bool
            }
            
            let universities: [UniversityViewModel]
        }
    }
    
    enum Favorite {
        struct Request {
            let universityID: Int
            let isFavorite: Bool
        }
        
        struct Response {
            let error: Error?
        }
        
        struct ViewModel {
            let errorMessage: String?
        }
    }
    
    // MARK: - Sorting options
    enum SortOption: String {
        case name
        case popularity
    }
}


struct UniversityModel: Codable {
    let email: String?
    let site: String?
    let description: String?
    let phone: String?
    
    let universityID: Int
    let name: String
    let shortName: String
    let logo: String
    let region: String
    var like: Bool?
    
    enum CodingKeys: String, CodingKey {
        case universityID = "university_id"
        case shortName = "short_name"
        case name, logo, region, like, email, site, description, phone
    }
}
