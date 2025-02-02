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
