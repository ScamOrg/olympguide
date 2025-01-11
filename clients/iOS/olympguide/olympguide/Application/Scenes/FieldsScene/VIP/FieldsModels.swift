//
//  FieldsModels.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Main screen: Fields
enum Fields {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let searchQuery: String?
            let degree: String?
        }
        
        struct Response {
            let groupsOfFields: [GroupOfFieldsModel]
        }
        
        struct ViewModel {
            struct GroupOfFieldsViewModel {
                struct FieldViewModel {
                    let name: String
                    let code: String
                }
                
                let name: String
                let code: String
                var isExpanded: Bool = false
                
                let fields: [FieldViewModel]
            }
            
            let groupsOfFields: [GroupOfFieldsViewModel]
        }
    }
}

struct GroupOfFieldsModel: Codable {
    struct FieldModel: Codable {
        let name: String
        let code: String
        let degree: String
    }
    
    let name: String
    let code: String
    let fields: [FieldModel]
}
