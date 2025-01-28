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
    func verifyCode(request: VerifyEmailModels.VerifyCode.Request)
    func resendCode(request: VerifyEmailModels.ResendCode.Request)
}

// MARK: - Data Store
/// Храним данные, которые могут потребоваться при переходе на другой экран
protocol VerifyEmailDataStore {
    var email: String? { get set }
    var time: Int? { get set }
}

// MARK: - Presentation Logic
protocol VerifyEmailPresentationLogic {
    func presentVerifyCode(response: VerifyEmailModels.VerifyCode.Response)
    func presentResendCode(response: VerifyEmailModels.ResendCode.Response)
}

// MARK: - Display Logic
protocol VerifyEmailDisplayLogic: AnyObject {
    func displayVerifyCodeResult(viewModel: VerifyEmailModels.VerifyCode.ViewModel)
    func displayResendCodeResult(viewModel: VerifyEmailModels.ResendCode.ViewModel)
}

// MARK: - Routing Logic
protocol VerifyEmailRoutingLogic {
    func routeToPersonalData()
}

// MARK: - Data Passing
protocol VerifyEmailDataPassing {
    var dataStore: VerifyEmailDataStore? { get }
}
