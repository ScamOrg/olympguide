//
//  EnterEmailProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

// MARK: - Business Logic
protocol EnterEmailBusinessLogic {
    func sendCode(request: EnterEmailModels.SendCode.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol EnterEmailDataStore {
    var email: String? { get set }
    var time: Int? { get set }
}

// MARK: - Presentation Logic
protocol EnterEmailPresentationLogic {
    func presentSendCode(response: EnterEmailModels.SendCode.Response)
}

// MARK: - Display Logic
protocol EnterEmailDisplayLogic: AnyObject {
    func displaySendCodeResult(viewModel: EnterEmailModels.SendCode.ViewModel)
}

// MARK: - Routing Logic
protocol EnterEmailRoutingLogic {
    func routeToVerifyCode()
}

// MARK: - Data Passing
protocol EnterEmailDataPassing {
    var dataStore: EnterEmailDataStore? { get }
}
