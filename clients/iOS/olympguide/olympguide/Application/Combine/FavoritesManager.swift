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
    
    @Published private(set) var likedPrograms: Set<Int> = []
    @Published private(set) var unlikedPrograms: Set<Int> = []
    
    let universityEventSubject = PassthroughSubject<UniversityFavoriteEvent, Never>()
    let programEventSubject = PassthroughSubject<ProgramFavoriteEvent, Never>()
    
    enum UniversityFavoriteEvent {
        case added(UniversityModel)
        case removed(Int)
        case error(Int)
        case access(Int, Bool)
    }
    
    enum ProgramFavoriteEvent {
        case added(ProgramModel)
        case removed(Int)
        case error(Int)
        case access(Int, Bool)
    }
    
    enum Subject {
        case University
        case Program
        case Olympiad
    }
    
    private init() {}
}

// MARK: - Universities
extension FavoritesManager {
    func addUniversityToFavorites(model: UniversityModel) {
        let id = model.universityID
        likedUniversities.insert(id)
        unlikedUniversities.remove(id)
        universityEventSubject.send(.added(model))
        
        FavoritesBatcher.shared.addUniversityChange(
            universityID: id,
            isFavorite: true
        )
    }
    
    func removeUniversityFromFavorites(universityID: Int) {
        likedUniversities.remove(universityID)
        unlikedUniversities.insert(universityID)
        universityEventSubject.send(.removed(universityID))
        
        FavoritesBatcher.shared.addUniversityChange(
            universityID: universityID,
            isFavorite: false
        )
    }
    
    func handleBatchError(for id: Int, subject: Subject){
        switch subject {
        case .University:
            likedUniversities.remove(id)
            unlikedUniversities.remove(id)
            universityEventSubject.send(.error(id))
        case .Program:
            likedPrograms.remove(id)
            unlikedPrograms.remove(id)
            programEventSubject.send(.error(id))
        case .Olympiad:
            break
        }
    }
    
    func handleBatchSuccess(for id: Int, isFavorite: Bool , subject: Subject){
        switch subject {
        case .University:
            universityEventSubject.send(.access(id, isFavorite))
        case .Program:
            programEventSubject.send(.access(id, isFavorite))
        case .Olympiad:
            break
        }
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


// MARK: - Programs
extension FavoritesManager {
    func addProgramToFavorites(viewModel: ProgramModel) {
        let id = viewModel.programID
        likedPrograms.insert(id)
        unlikedPrograms.remove(id)
        programEventSubject.send(.added(viewModel))
        FavoritesBatcher.shared.addProgramChange(
            programID: id,
            isFavorite: true
        )
    }
    
    func removeProgramFromFavorites(programID: Int) {
        likedPrograms.remove(programID)
        unlikedPrograms.insert(programID)
        programEventSubject.send(.removed(programID))
        FavoritesBatcher.shared.addProgramChange(
            programID: programID,
            isFavorite: false
        )
    }
    
    func isProgramFavorited(programID: Int, serverValue: Bool) -> Bool {
        if serverValue, unlikedPrograms.contains(programID) {
            return false
        }
        if !serverValue, likedPrograms.contains(programID) {
            return true
        }
        return serverValue
    }
}
