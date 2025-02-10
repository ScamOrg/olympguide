//
//  PersonalDataInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import Foundation

final class PersonalDataInteractor : PersonalDataBusinessLogic {
    var presenter: PersonalDataPresentationLogic?
    private let worker = PersonalDataWorker()
    
    func signUp(request: PersonalData.SignUp.Request) {
        guard
            let email = request.email?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
            let password = request.password?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty,
            let firstName = request.firstName?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty,
            let lastName = request.lastName?.trimmingCharacters(in: .whitespacesAndNewlines), !lastName.isEmpty,
            let birthday = request.birthday?.trimmingCharacters(in: .whitespacesAndNewlines), !birthday.isEmpty,
            let regionId = request.regionId
        else {
            presenter?.presentError(message: "")
            return
        }
        
        let secondName = request.secondName ?? ""
        
        guard request.secondName == nil || !secondName.isEmpty else {
            presenter?.presentError(message: "")
            return
        }
        
        worker.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            secondName: secondName,
            birthday: birthday,
            regionId: regionId
        )
        { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                let response = PersonalData.SignUp.Response(
                    success: true,
                    error: nil
                )
                self.presenter?.presentSignUp(response: response)
                
            case .failure(let networkError):
                let response = PersonalData.SignUp.Response(
                    success: false,
                    error: networkError as NSError
                )
                self.presenter?.presentSignUp(response: response)
            }
        }
    }
}
