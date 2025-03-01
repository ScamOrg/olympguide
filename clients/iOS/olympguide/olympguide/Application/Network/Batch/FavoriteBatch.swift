//
//  FavoriteBatch.swift
//  olympguide
//
//  Created by Tom Tim on 28.02.2025.
//

import UIKit

final class FavoriteBatch {
    typealias EndpointFormatter = (Int, Bool) -> String
    typealias MethodForValue = (Bool) -> HTTPMethod
    private let syncQueue = DispatchQueue(label: "com.olypmguide.favoriteBatcher.queue")
    
    private var changes: [Int: Bool] = [:]
    private var timer: Timer?
    private let timeInterval: TimeInterval
    private let endpointFormatter: EndpointFormatter
    private let methodForValue: MethodForValue
    private let subject: FavoritesManager.Subject
    
    init(
        timeInterval: TimeInterval = 2.0,
        subject: FavoritesManager.Subject,
        endpointFormatter: @escaping EndpointFormatter,
        methodForValue: @escaping MethodForValue
    ) {
        self.subject = subject
        self.timeInterval = timeInterval
        self.endpointFormatter = endpointFormatter
        self.methodForValue = methodForValue
    }
    
    func addChange(id: Int, isFavorite: Bool) {
        changes[id] = isFavorite
        scheduleTimer()
    }
    
    private func scheduleTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(sendBatch),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc func sendBatch() {
        syncQueue.async { [weak self] in
            guard let self = self, !self.changes.isEmpty else { return }
            let pendingChanges = self.changes
            self.changes.removeAll()
            DispatchQueue.main.async {
                self.timer?.invalidate()
            }
            
            for (id, isFavorite) in pendingChanges {
                let endpoint = self.endpointFormatter(id, isFavorite)
                let method = self.methodForValue(isFavorite)
                
                NetworkService().request(
                    endpoint: endpoint,
                    method: method,
                    queryItems: nil,
                    body: nil
                ) { [weak self] (result: Result<BaseServerResponse, NetworkError>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            FavoritesManager.shared.handleBatchSuccess(for: id, isFavorite: isFavorite, subject: self.subject)
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            FavoritesManager.shared.handleBatchError(for: id, subject: self.subject)
                        }
                    }
                }
            }
        }
    }
}
