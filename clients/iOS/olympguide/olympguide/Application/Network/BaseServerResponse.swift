//
//  BaseServerResponse.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

struct BaseServerResponse: Decodable {
    let message: String?
    let type: String?
    let time: Int?
    // let data: [String: Any]?
}
