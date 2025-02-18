//
//  PersonalDataPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

final class PersonalDataPresenter : PersonalDataPresentationLogic {
    
    weak var view: (PersonalDataDisplayLogic & ValidationErrorDisplayable)?
    
    func presentSignUp(response: PersonalData.SignUp.Response) {
        if response.success {
            let viewModel = PersonalData.SignUp.ViewModel(errorMessage: nil)
            view?.displaySignUp(viewModel: viewModel)
            return
        }
        
        var errorMessages: [String] = []
        
        if let error = response.error as? AppError {
            switch error {
            case .network(let networkError):
                errorMessages.append(networkError.localizedDescription)
            case .validation(let validationErrors):
                errorMessages.append(contentsOf: validationErrors.map { $0.localizedDescription })
                highlightValidationErrors(validationErrors)
            }
        } else {
            errorMessages.append("Произошла неизвестная ошибка")
        }
        
        let viewModel = PersonalData.SignUp.ViewModel(errorMessage: errorMessages)
        view?.displaySignUp(viewModel: viewModel)
    }
    
    private func highlightValidationErrors(_ errors: [ValidationError]) {
        for error in errors {
            switch error {
            case .emptyField(let fieldName):
                if fieldName.lowercased() == "пароль" {
                    view?.passwordTextField.highlightError()
                }
            case .weakPassword, .shortPassword, .passwordWithoutLowercaseLetter, .passwordWithoutUpperrcaseLetter, .passwordWithoutDigit:
                view?.passwordTextField.highlightError()
            case .invalidLastName:
                view?.lastNameTextField.highlightError()
            case .invalidFirstName:
                view?.nameTextField.highlightError()
            case .invalidSecondName:
                view?.secondNameTextField.highlightError()
            case .invalidBirthay:
                view?.birthdayPicker.highlightError()
            case .invalidRegion:
                view?.regionTextField.highlightError()
            default:
                break
            }
        }
    }
}
