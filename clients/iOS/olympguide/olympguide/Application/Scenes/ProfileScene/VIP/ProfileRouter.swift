//
//  ProfileRouter.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class ProfileRouter: ProfileRoutingLogic {
    weak var viewController: UIViewController?
    
    func routeToSignIn() {
        let signInVC = SignInAssembly.build()
        viewController?.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    func routeToSignUp() {
//        let enterEmailVC = EnterEmailAssembly.build()
        let enterEmailVC = PersonalDataAssembly.build(email: "")
        viewController?.navigationController?.pushViewController(enterEmailVC, animated: true)
    }
    
    func routToAboutUs() {
        let aboutUsVC = AboutUsViewController()
        viewController?.navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    
    func routToFavoriteOlympiads() {
        let favoriteOlympiadsVC = FavoriteOlympiadsAssembly.build()
        viewController?.navigationController?.pushViewController(favoriteOlympiadsVC, animated: true)
    }
    
    func routToFavoriteUniversities() {
        let favoriteUniversitiesVC = FavoriteUniversitiesAssembly.build()
        viewController?.navigationController?.pushViewController(favoriteUniversitiesVC, animated: true)
    }
    
    func routToFavoritePrograms() {
        let favoriteProgramsVC = FavoriteProgramsAssembly.build()
        viewController?.navigationController?.pushViewController(favoriteProgramsVC, animated: true)
    }
}

