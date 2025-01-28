//
//  NetworkMonitor.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import Foundation
import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var disconnectVC: DisconnectViewController?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.hideDisconnectViewController()
                } else {
                    self?.showDisconnectViewController()
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func topMostController() -> UIViewController? {
        var topController = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        return topController
    }

    private func showDisconnectViewController() {
        guard disconnectVC == nil, let topVC = topMostController() else { return }
        let disconnectVC = DisconnectViewController()
        disconnectVC.onReconnect = {
            // MARK: Нужно прописать какую-нибудь логику
        }
        disconnectVC.modalPresentationStyle = .fullScreen
        topVC.present(disconnectVC, animated: true, completion: nil)
        self.disconnectVC = disconnectVC
    }

    private func hideDisconnectViewController() {
        disconnectVC?.dismiss(animated: true, completion: nil)
        disconnectVC = nil
    }
}

