//
//  UniversityModels.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation

enum University {
    enum Load {
        struct Request {
            let universityID: Int
        }
        
        struct Response {
            let error: Error?
            let site: String?
            let email: String?
        }
        
        struct ViewModel {
            let site: String
            let email: String
        }
    }
}
