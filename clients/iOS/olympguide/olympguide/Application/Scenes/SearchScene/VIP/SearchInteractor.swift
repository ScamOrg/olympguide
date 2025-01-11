//
//  File.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Foundation

final class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    
    // MARK: - VIP
    var presenter: SearchPresentationLogic?
    private let worker = SearchWorker()
    
    // MARK: - DataStore
    var searchType: SearchType?
    var results: [String] = []
    
    // MARK: - Business Logic
    
    func loadScene(request: Search.Load.Request) {
        self.searchType = request.searchType
        
        let titleForScene: String
        titleForScene = "Поиск"
        
        // Презентуем заголовок
        let response = Search.Load.Response(title: titleForScene)
        presenter?.presentLoadScene(response: response)
        
        // 1) Сразу же делаем «пустой» запрос — чтобы отобразить дефолтный список
        let textDidChangeRequest = Search.TextDidChange.Request(query: "")
        textDidChange(request: textDidChangeRequest)
    }
    
    // SearchInteractor.swift
    func textDidChange(request: Search.TextDidChange.Request) {
        guard let type = searchType else { return }
        let allItems = worker.fetchData(for: type)
        let filtered = worker.filter(items: allItems, with: request.query)
        results = filtered
        let response = Search.TextDidChange.Response(results: filtered)
        presenter?.presentTextDidChange(response: response)
    }
    
    func selectItem(request: Search.SelectItem.Request) {
        guard request.index < results.count else { return }
        let selected = results[request.index]
        
        let response = Search.SelectItem.Response(selectedItem: selected)
        presenter?.presentSelectItem(response: response)
    }
}
