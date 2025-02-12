//
//  PersonalDataPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

final class PersonalDataPresenter : PersonalDataPresentationLogic {
    
    weak var viewController: PersonalDataDisplayLogic?
    
    func presentSignUp(response: PersonalData.SignUp.Response) {
        let viewModel = PersonalData.SignUp.ViewModel(errorMessage: nil)
        viewController?.displaySignUp(viewModel: viewModel)
    }
    
    func presentError(with error: any Error) {
        let viewModel = PersonalData.SignUp.ViewModel(errorMessage: error.localizedDescription)
        viewController?.displaySignUp(viewModel: viewModel)
    }
}
