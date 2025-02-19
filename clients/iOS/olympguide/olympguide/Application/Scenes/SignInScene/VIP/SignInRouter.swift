//
//  SignInRouter.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class SignInRouter: SignInRoutingLogic {
    weak var viewController: UIViewController?
    
    func routeToRoot() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
