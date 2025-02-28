//
//  FavoriteBatch.swift
//  olympguide
//
//  Created by Tom Tim on 28.02.2025.
//

import UIKit

final class FavoriteBatch<ID: Hashable> {
    typealias EndpointFormatter = (ID, Bool) -> String
    typealias MethodForValue = (Bool) -> HTTPMethod
    private let syncQueue = DispatchQueue(label: "com.olypmguide.favoriteBatcher.queue")
    
    private var changes: [ID: Bool] = [:]
    private var timer: Timer?
    private let timeInterval: TimeInterval
    private let endpointFormatter: EndpointFormatter
    private let methodForValue: MethodForValue
    
    init(timeInterval: TimeInterval = 2.0,
         endpointFormatter: @escaping EndpointFormatter,
         methodForValue: @escaping MethodForValue) {
        self.timeInterval = timeInterval
        self.endpointFormatter = endpointFormatter
        self.methodForValue = methodForValue
    }
    
    func addChange(id: ID, isFavorite: Bool) {
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
        guard !changes.isEmpty else { return }
        let pendingChanges = changes
        changes.removeAll()
        timer?.invalidate()
        
        for (id, isFavorite) in pendingChanges {
            let endpoint = endpointFormatter(id, isFavorite)
            let method = methodForValue(isFavorite)
            NetworkService().request(
                endpoint: endpoint,
                method: method,
                queryItems: nil,
                body: nil
            ) { (result: Result<BaseServerResponse, NetworkError>) in
            }
        }
    }
}
