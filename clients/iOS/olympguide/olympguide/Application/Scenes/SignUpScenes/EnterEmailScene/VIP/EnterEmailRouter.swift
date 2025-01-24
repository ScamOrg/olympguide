//
//  EnterEmailRouter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class EnterEmailRouter: EnterEmailRoutingLogic, EnterEmailDataPassing {
    
    weak var viewController: UIViewController?
    var dataStore: EnterEmailDataStore?
    
    func routeToInputCode() {
        // Предположим, у нас есть класс InputCodeViewController
        // (можете создать по аналогии свой VIP-модуль или обычный контроллер)
        let email = dataStore?.email
        let inputCodeVC = VerifyEmailViewController(email: email ?? "")
        
        // Если нужно передать email в следующий экран:
        // inputCodeVC.email = dataStore?.email
        
        viewController?.navigationController?.pushViewController(inputCodeVC, animated: true)
    }
}
