//
//  PersonalDataProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

// MARK: - Business Logic
protocol PersonalDataBusinessLogic {
    func signUp(request: PersonalData.SignUp.Request)
}

//// MARK: - Data Store
//protocol PersonalDataEmailDataStore {
//    var email: String? { get set }
//    var time: Int? { get set }
//}

// MARK: - Presentation Logic
protocol PersonalDataPresentationLogic {
    func presentSignUp(response: PersonalData.SignUp.Response)
    func presentError(with error: Error)
}

// MARK: - Display Logic
protocol PersonalDataDisplayLogic: AnyObject {
    func displaySignUp(viewModel: PersonalData.SignUp.ViewModel)
    func displayError(message: String)
}

// MARK: - Routing Logic
protocol PersonalDataRoutingLogic {
    func routeToVerifyCode()
}

// MARK: - Data Passing
protocol PersonalDataDataPassing {
    var dataStore: EnterEmailDataStore? { get }
}
