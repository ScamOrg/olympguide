//
//  VerifyEmailProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation
import UIKit

// MARK: - Business Logic
protocol VerifyEmailBusinessLogic {
    func verifyCode(request: VerifyEmailModels.SendCode.Request)
}

// MARK: - Data Store
/// Храним данные, которые могут потребоваться при переходе на другой экран
protocol VerifyEmailDataStore {
    var email: String? { get set }
}

// MARK: - Presentation Logic
protocol VerifyEmailPresentationLogic {
    func presentVerifyCode(response: VerifyEmailModels.SendCode.Response)
}

// MARK: - Display Logic
protocol VerifyEmailDisplayLogic: AnyObject {
    func displayVerifyCodeResult(viewModel: VerifyEmailModels.SendCode.ViewModel)
}

// MARK: - Routing Logic
protocol VerifyEmailRoutingLogic {
    func routeToInputCode()
}

// MARK: - Data Passing
protocol VerifyEmailDataPassing {
    var dataStore: VerifyEmailDataStore? { get }
}
