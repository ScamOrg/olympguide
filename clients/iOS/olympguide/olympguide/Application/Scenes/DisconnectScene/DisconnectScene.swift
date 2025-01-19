//
//  DisconnectScene.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import UIKit
import Network

class DisconnectViewController: UIViewController {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var onReconnect: (() -> Void)?

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Проблемы со связью"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "MontserratAlternates-Medium", size: 20)
        return label
    }()

    private let disconnectImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "wifi.slash"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Проверьте подключение к интернету"
        label.textAlignment = .center
        label.font = UIFont(name: "MontserratAlternates-Regular", size: 14)
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#999999")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startMonitoring()
    }

    private func setupUI() {
        view.addSubview(messageLabel)
        view.addSubview(disconnectImageView)
        view.addSubview(descriptionLabel)
        
        disconnectImageView.setWidth(64)
        disconnectImageView.setHeight(64)
        
        descriptionLabel.pinCenter(to: view)
        
        disconnectImageView.pinCenterX(to: view)
        disconnectImageView.pinBottom(to: messageLabel.topAnchor, 21)
        
        messageLabel.pinCenterX(to: view)
        messageLabel.pinBottom(to: descriptionLabel.topAnchor, 9)
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    // Интернет восстановлен, вызов замыкания и закрытие экрана
                    self?.onReconnect?()
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func checkInternetConnection() {
        // Принудительно проверяем состояние сети
        if monitor.currentPath.status == .satisfied {
            // Интернет восстановлен
            onReconnect?()
            dismiss(animated: true, completion: nil)
        } else {
            // Интернет всё ещё недоступен
            let alert = UIAlertController(title: "Ошибка", message: "Подключение отсутствует", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func refreshTapped() {
        checkInternetConnection()
    }
}
