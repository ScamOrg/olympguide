//
//  OptionModels.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

enum Options {
    enum TextDidChange {
        struct Request {
            let query: String
        }
        struct Response {
            let options: [OptionModel]
        }
        struct ViewModel {
            let options: [OptionModel]
        }
    }
    
    enum FetchOptions {
        struct Request {
            let endPoint: String
        }
        
        struct Response {
            let options: [Option]
        }
        
        struct ViewModel {
            
        }
    }
}

class OptionModel {
    let title: String
    let realIndex: Int
    var currentIndex: Int
    
    init(title: String, realIndex: Int, currentIndex: Int) {
        self.title = title
        self.realIndex = realIndex
        self.currentIndex = currentIndex
    }
}

enum OptionsModels {
    enum Region {
        struct ResponseModel : Codable {
            let name: String
            let id: Int
            enum CodingKeys: String, CodingKey {
                case id = "region_id"
                case name
            }
        }
        
        struct ViewModel : Option {
            var id: Int
            var name: String
        }
    }
}

struct Option {
    var id: Int
    var name: String
}

