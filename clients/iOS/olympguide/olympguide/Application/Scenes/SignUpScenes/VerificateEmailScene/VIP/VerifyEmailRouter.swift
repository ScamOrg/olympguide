//
//  EnterEmailRouter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerifyEmailRouter: VerifyEmailRoutingLogic, VerifyEmailDataPassing {
    
    weak var viewController: UIViewController?
    var dataStore: VerifyEmailDataStore?
    
    func routeToInputCode() {
        let email = dataStore?.email
        let inputCodeVC = VerifyEmailViewController(email: email ?? "")
        
        viewController?.navigationController?.pushViewController(inputCodeVC, animated: true)
    }
}
