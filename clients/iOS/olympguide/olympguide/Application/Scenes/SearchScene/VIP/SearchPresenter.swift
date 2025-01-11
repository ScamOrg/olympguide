//
//  SearchPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Foundation

final class SearchPresenter: SearchPresentationLogic {
    
    weak var viewController: SearchDisplayLogic?
    
    func presentLoadScene(response: Search.Load.Response) {
        let vm = Search.Load.ViewModel(navBarTitle: response.title)
        viewController?.displayLoadScene(viewModel: vm)
    }
    
    func presentTextDidChange(response: Search.TextDidChange.Response) {
        let vm = Search.TextDidChange.ViewModel(items: response.results)
        viewController?.displayTextDidChange(viewModel: vm)
    }
    
    func presentSelectItem(response: Search.SelectItem.Response) {
        let vm = Search.SelectItem.ViewModel(selectedItemTitle: response.selectedItem)
        viewController?.displaySelectItem(viewModel: vm)
    }
}
