//
//  SearchWorker.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Foundation

final class SearchWorker {
    
    /// Имитируем запрос в базу данных или сеть
    /// Можно расширить под конкретные нужды
    func fetchData(for type: SearchType) -> [String] {
        switch type {
        case .universities:
            return ["МГУ", "СПбГУ", "МФТИ", "ВШЭ", "Финансовый университет"]
        case .olympiads:
            return ["Ломоносов", "Физтех", "Высшая проба", "Инфоурок"]
        case .fields:
            return ["Item 1", "Item 2", "Item 3"]
        }
    }
    
    /// Простейший метод для фильтрации полученного массива по строке
    func filter(items: [String], with query: String) -> [String] {
        guard !query.isEmpty else { return items }
        return items.filter { $0.lowercased().contains(query.lowercased()) }
    }
}
