//
//  PersonalDataModels.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

enum PersonalData {
    enum signUP {
        struct Request {
            let email: String?
            let password: String?
            let firstName: String?
            let lastName: String?
            let secondName: String?
            let birthday: String?
            let region_id: Int?
        }
        
        struct Response {
            let success: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let name: String
        }
    }
    
    enum LoadRegions {
        struct Response {
            let regions: [OptionsModels.Region.ResponseModel]
        }
        struct ViewModel {
            let regions: [OptionsModels.Region.ViewModel]
        }
    }
    
}
