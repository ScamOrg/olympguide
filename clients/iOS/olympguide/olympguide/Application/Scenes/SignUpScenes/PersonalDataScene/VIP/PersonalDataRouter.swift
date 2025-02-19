//
//  PersonalDataRouter.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import UIKit

final class PersonalDataRouter : PersonalDataRoutingLogic {
    weak var viewController: UIViewController?
    
    func routeToRoot(email: String, password: String) {
        AuthManager.shared.login(email: email, password: password) {[weak self] result in
            let previousViewController = self?.viewController?.navigationController?.viewControllers.dropLast().last
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self?.viewController?.navigationController?.popViewController(animated: true)
            }
            switch result {
            case .failure:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    previousViewController?.showAlert(title: "Поздравляем!" ,with: "Вы успешно зарегистрировались")
                }
            case .success:
                break
            }
            
        }
    }
}
