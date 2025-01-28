//
//  VerificateEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerifyEmailViewController: UIViewController {
    var interactor: VerifyEmailBusinessLogic?
    var router: (VerifyEmailRoutingLogic & VerifyEmailDataPassing)?
    
    private var userEmail: String
    private var timer: Timer?
    private var remainingTime: Int
    
    private let timerLabel = UIButton()
//    private let timerLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let verifyCodeField = VerifyCodeField()
    
    init(email: String, time: Int) {
        self.remainingTime = time
        self.userEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Подтвердите почту"
        configure()
        configureUI()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifyCodeField.setFocusToFirstField()
    }
    
    private func configure() {
        let viewController = self
        let interactor = VerifyEmailInteractor()
        let presenter = VerifyEmailPresenter()
        let router = VerifyEmailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "Подтвердите почту"
        
        configureDescriptioLabel()
        configureVerifyCodeField()
        configureTimerLabel()
    }
    
    private func configureDescriptioLabel() {
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Введите четырёхзначный код, присланный на \(userEmail)"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 12) ?? .systemFont(ofSize: 12)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 13)
        descriptionLabel.pinLeft(to: view.leadingAnchor, 20)
        descriptionLabel.pinRight(to: view.trailingAnchor, 20)
    }
    
    private func configureVerifyCodeField() {
        view.addSubview(verifyCodeField)
        
        verifyCodeField.pinTop(to: descriptionLabel.bottomAnchor, 50)
        verifyCodeField.pinCenterX(to: view)
        
        verifyCodeField.onComplete = {[weak self] code in
            let request = VerifyEmailModels.VerifyCode.Request(code: code, email: self?.userEmail ?? "")
            self?.interactor?.verifyCode(request: request)
        }
    }
    
    private func configureTimerLabel() {
        view.addSubview(timerLabel)
        
        timerLabel.setTitle(formatTimeMessage(remainingTime), for: .normal)
        timerLabel.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 10) ?? .systemFont(ofSize: 10)
        timerLabel.titleLabel?.numberOfLines = 0
        timerLabel.titleLabel?.textAlignment = .center
//        timerLabel.titleLabel?.text = formatTimeMessage(remainingTime)
        timerLabel.backgroundColor = .clear
        timerLabel.setTitleColor(.black, for: .normal)
//        timerLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 10) ?? .systemFont(ofSize: 10)
//        timerLabel.textAlignment = .center
//        timerLabel.text = formatTimeMessage(remainingTime)
//        timerLabel.numberOfLines = 0
        
        timerLabel.pinCenterX(to: view)
        timerLabel.pinTop(to: verifyCodeField.bottomAnchor, 42)
        
        timerLabel.addTarget(self, action: #selector(resendCodeTapped), for: .touchUpInside)
    }
    
    private func formatTimeMessage(_ time: Int) -> String {
            // Форматирование сообщения с временем
            let minutes = time / 60
            let seconds = time % 60
            let formattedTime = String(format: "%02d:%02d", minutes, seconds)
            return "Запросить следующий код можно через\n\(formattedTime)"
        }
    
    private func startTimer() {
        // Создание и запуск таймера
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTimer()
        }
    }
    
    private func updateTimer() {
        // Обновление оставшегося времени и интерфейса
        if remainingTime > 0 {
            remainingTime -= 1
//            timerLabel.set = formatTimeMessage(remainingTime)
            timerLabel.setTitle(formatTimeMessage(remainingTime), for: .normal)
//            timerLabel.titleLabel?.text = formatTimeMessage(remainingTime)
        } else {
            timer?.invalidate()
            timer = nil
            handleTimerEnd()
        }
    }
    
    private func handleTimerEnd() {
        timerLabel.setTitle("Запроcить код снова", for: .normal)
    }
    
    @objc
    func resendCodeTapped() {
        if timer == nil {
            interactor?.resendCode(request: VerifyEmailModels.ResendCode.Request(email: userEmail))
        }
    }
}

extension VerifyEmailViewController: VerifyEmailDisplayLogic {
    func displayResendCodeResult(viewModel: VerifyEmailModels.ResendCode.ViewModel) {
        remainingTime = 180
        timer?.invalidate()
        timer = nil
        startTimer()
    }
    
    func displayVerifyCodeResult(viewModel: VerifyEmailModels.VerifyCode.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            verifyCodeField.makeRed()
        } else {
            router?.routeToPersonalData()
        }
    }
}
