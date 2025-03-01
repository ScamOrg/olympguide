//
//  UniversitiesInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Universitiesnteractor
final class UniversitiesInteractor: UniversitiesBusinessLogic, UniversitiesDataStore {
    var presenter: UniversitiesPresentationLogic?
    var worker: UniversitiesWorkerLogic?
    var universities: [UniversityModel] = []
    var params: Dictionary<String, Set<String>> = [:]
    var removeUniversities: [Int: UniversityModel] = [:]
    
    func loadUniversities(_ request: Universities.Load.Request) {
        params = request.params
        worker?.fetchUniversities(
            with: []
        ) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities ?? []
                let response = Universities.Load.Response(universities: universities ?? [])
                self?.presenter?.presentUniversities(response: response)
            case .failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
    
    func handleBatchError(universityID: Int) {
        if let university = removeUniversities[universityID] {
            let insetrIndex = universities.firstIndex { $0.universityID > university.universityID} ?? universities.count
            universities.insert(university, at: insetrIndex)
        } else {
            if let removeIndex = universities.firstIndex(where: { $0.universityID == universityID }) {
                universities.remove(at: removeIndex)
            }
        }
        
        let response = Universities.Load.Response(universities: universities)
        presenter?.presentUniversities(response: response)
    }
    
    func handleBatchSuccess(universityID: Int, isFavorite: Bool) {
        if !isFavorite {
            removeUniversities[universityID] = nil
        }
    }
    
    func dislikeUniversity(at index: Int) {
        let university = universities.remove(at: index)
        removeUniversities[university.universityID] = university
    }
    
    func likeUniversity(_ university: UniversityModel, at insertIndex: Int) {
        universities.insert(university, at: insertIndex)
        removeUniversities[university.universityID] = nil
    }
    
    func universityModel(at index: Int) -> UniversityModel {
        universities[index]
    }
    
    func restoreFavorite(at index: Int) -> Bool {
        universities[index].like ?? false
    }
}
