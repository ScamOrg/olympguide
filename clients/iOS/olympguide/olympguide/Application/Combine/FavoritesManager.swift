//
//  FavoritesManager.swift
//  olympguide
//
//  Created by Tom Tim on 28.02.2025.
//

import Combine

final class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published private(set) var likedUniversities: Set<Int> = []
    @Published private(set) var unlikedUniversities: Set<Int> = []
    
    let universityEventSubject = PassthroughSubject<UniversityFavoriteEvent, Never>()
    
    enum UniversityFavoriteEvent {
        case added(Universities.Load.ViewModel.UniversityViewModel)
        case removed(Int)
        case error(Int)
    }
    
    private init() {}
    
    func addUniversityToFavorites(viewModel: Universities.Load.ViewModel.UniversityViewModel) {
        let id = viewModel.universityID
        likedUniversities.insert(id)
        unlikedUniversities.remove(id)
        universityEventSubject.send(.added(viewModel))
    }
    
    func addUniversityToFavorites(model: UniversityModel) {
        let viewModel = Universities.Load.ViewModel.UniversityViewModel(
            universityID: model.universityID,
            name: model.name,
            logoURL: model.logo,
            region: model.region,
            like: model.like ?? false
        )
        addUniversityToFavorites(viewModel: viewModel)
    }
    
    func removeUniversityFromFavorites(universityID: Int) {
        likedUniversities.remove(universityID)
        unlikedUniversities.insert(universityID)
        universityEventSubject.send(.removed(universityID))
    }
    
    func handleBatchError(for universityID: Int) {
        likedUniversities.remove(universityID)
        unlikedUniversities.remove(universityID)
        universityEventSubject.send(.error(universityID))
    }
    
    func isUniversityFavorited(universityID: Int, serverValue: Bool) -> Bool {
        if serverValue, unlikedUniversities.contains(universityID) {
            return false
        }
        if !serverValue, likedUniversities.contains(universityID) {
            return true
        }
        return serverValue
    }
}
