//
//  SearchModels.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Foundation

/// Тип поиска — определяем, по чему мы ищем
enum SearchType {
    case universities
    case olympiads
    case other
    
    func title() -> String {
        switch self {
        case .universities: return "Поиск по ВУЗам"
        case .olympiads: return "Поиск по олимпиадам"
        case .other: return "other"
        }
    }
}

enum Search {
    
    // MARK: - Загрузка сцены
    enum Load {
        struct Request {
            let searchType: SearchType
        }
        struct Response {
            let title: String
        }
        struct ViewModel {
            let navBarTitle: String
        }
    }
    
    // MARK: - Изменение текста поиска
    enum TextDidChange {
        struct Request {
            let query: String
        }
        struct Response {
            let results: [String]
        }
        struct ViewModel {
            let items: [String]
        }
    }
    
    // MARK: - Выбор элемента из списка
    enum SelectItem {
        struct Request {
            let index: Int
        }
        struct Response {
            let selectedItem: String
        }
        struct ViewModel {
            let selectedItemTitle: String
        }
    }
}
