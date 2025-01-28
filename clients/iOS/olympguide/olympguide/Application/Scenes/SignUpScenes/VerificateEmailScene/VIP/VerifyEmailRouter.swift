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
    
    func routeToPersonalData() {
        let email = dataStore?.email
        let inputCodeVC = PersonalDataViewController(email: email ?? "")
        
        viewController?.navigationController?.pushViewController(inputCodeVC, animated: true)
    }
}
