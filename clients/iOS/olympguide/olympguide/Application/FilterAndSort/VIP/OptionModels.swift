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
            struct Dependencies {
                let realIndex: Int
                let currentIndex: Int
            }
            
            let options: [Dependencies]
        }
        struct ViewModel {
            struct DependenciesViewModel {
                let realIndex: Int
                let currentIndex: Int
            }
            
            let dependencies: [DependenciesViewModel]
        }
    }
    
    enum FetchOptions {
        struct Request {
            let endPoint: String
        }
        
        struct Response {
            let options: [DynamicOption]
        }
        
        struct ViewModel {
            struct OptionViewModel {
                let id: Int
                let name: String
            }
            
            let options: [OptionViewModel]
        }
    }
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

struct DynamicOption: Decodable {
    let id: Int
    let name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var idValue: Int?
        var nameValue: String?
        
        for key in container.allKeys {
            if key.stringValue == "name" {
                nameValue = try container.decode(String.self, forKey: key)
            } else if key.stringValue.hasSuffix("_id") {
                idValue = try container.decode(Int.self, forKey: key)
            }
        }
        
        guard let idValue, let nameValue else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Отсутствует один из необходимых ключей: id или name"
                )
            )
        }
        
        self.id = idValue
        self.name = nameValue
    }
}

