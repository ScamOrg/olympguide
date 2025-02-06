//
//  PersonalDataProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

// MARK: - Business Logic
protocol PersonalDataBusinessLogic {
    func signUp(request: EnterEmailModels.SendCode.Request)
    func loadRegions()
}

// MARK: - Data Store
protocol PersonalDataEmailDataStore {
    var email: String? { get set }
    var time: Int? { get set }
}

// MARK: - Presentation Logic
protocol PersonalDataPresentationLogic {
    func presentSendCode(response: EnterEmailModels.SendCode.Response)
}

// MARK: - Display Logic
protocol PersonalDataDisplayLogic: AnyObject {
    func displaySendCodeResult(viewModel: EnterEmailModels.SendCode.ViewModel)
}

// MARK: - Routing Logic
protocol PersonalDataRoutingLogic {
    func routeToVerifyCode()
}

// MARK: - Data Passing
protocol PersonalDataDataPassing {
    var dataStore: EnterEmailDataStore? { get }
}
