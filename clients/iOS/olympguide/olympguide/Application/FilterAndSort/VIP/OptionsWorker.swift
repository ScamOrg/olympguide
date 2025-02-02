//
//  OptionsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

final class OptionsWorker {
    func filter(items: [OptionModel], with query: String) -> [OptionModel] {
        let result = items.filter {
            $0.title
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .contains(query.lowercased()) || query.isEmpty
        }
        for (index, item) in result.enumerated() {
            item.currentIndex = index
        }
        
        return result
    }
}
