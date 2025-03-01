//
//  FavoritesBatcher.swift
//  olympguide
//
//  Created by Tom Tim on 28.02.2025.
//

import UIKit

final class FavoritesBatcher {
    static let shared = FavoritesBatcher()
    
    private let universitiesBatch = FavoriteBatch(
        subject: .University,
        endpointFormatter: { id, isFavorite in
            return "/user/favourite/university/\(id)"
        },
        methodForValue: { isFavorite in
            return isFavorite ? .post : .delete
        }
    )
    
    private let programsBatch = FavoriteBatch(
        subject: .Program,
        endpointFormatter: { id, isFavorite in
            return "/user/favourite/program/\(id)"
        },
        methodForValue: { isFavorite in
            return isFavorite ? .post : .delete
        }
    )
    
    private let olympiadsBatch = FavoriteBatch(
        subject: .Olympiad,
        endpointFormatter: { id, isFavorite in
            return "/user/favourite/olympiad/\(id)"
        },
        methodForValue: { isFavorite in
            return isFavorite ? .post : .delete
        }
    )
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    func addUniversityChange(universityID: Int, isFavorite: Bool) {
        universitiesBatch.addChange(id: universityID, isFavorite: isFavorite)
    }
    
    func addProgramChange(programID: Int, isFavorite: Bool) {
        programsBatch.addChange(id: programID, isFavorite: isFavorite)
    }
    
    func addOlympiadChange(olympiadID: Int, isFavorite: Bool) {
        olympiadsBatch.addChange(id: olympiadID, isFavorite: isFavorite)
    }
    
    @objc func sendBatch() {
        universitiesBatch.sendBatch()
        programsBatch.sendBatch()
        olympiadsBatch.sendBatch()
    }
    
    @objc private func applicationDidEnterBackground() {
        sendBatch()
    }
    
    @objc private func applicationWillTerminate() {
        sendBatch()
    }
}
