//
//  ProfileAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class ProfileAssembly {
    static func build() -> UIViewController {
        let viewController = ProfileViewController()
        let router = ProfileRouter()
        
        viewController.router = router
        router.viewController = viewController
        
        return viewController
    }
}
