//
//  UniversitiesModels.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Главный экран: Университеты
enum Universities {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let regionID: Int?
            let sortOption: SortOption?
            let searchQuery: String?
        }
        
        struct Response {
            let universities: [University]
        }
        
        struct ViewModel {
            struct UniversityViewModel {
                let name: String
                let logoURL: String
                let description: String
                let popularity: String
            }
            
            let universities: [UniversityViewModel] 
        }
    }
    
    // MARK: - Опции сортировки
    enum SortOption: String {
        case name
        case popularity
    }
}


struct University: Codable {
    let universityID: Int
    let name: String
    let logo: String
    let description: String
    let regionID: Int
    let popularity: Int
    let link: String

    enum CodingKeys: String, CodingKey {
        case universityID = "university_id"
        case name, logo, description
        case regionID = "region_id"
        case popularity, link
    }
}
