//
//  VerificateEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerifyEmailViewController: UIViewController, VerifyEmailDisplayLogic {
    var interactor: VerifyEmailBusinessLogic?
    var router: (VerifyEmailRoutingLogic & VerifyEmailDataPassing)?
    
    private var userEmail: String = ""
    
    private let descriptionLabel = UILabel()
    private let verifyCodeField = VerifyCodeField()
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.userEmail = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Подтвердите почту"
        configure()
        configureUI()
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
    }
    
    private func configureDescriptioLabel() {
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Введите четырёхзначный код присланный на\n\(userEmail)"
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
    
    func displayVerifyCodeResult(viewModel: VerifyEmailModels.VerifyCode.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            verifyCodeField.makeRed()
        } else {
            router?.routeToInputCode()
        }
    }
    // pankratovvlad1@gmail.com
}
