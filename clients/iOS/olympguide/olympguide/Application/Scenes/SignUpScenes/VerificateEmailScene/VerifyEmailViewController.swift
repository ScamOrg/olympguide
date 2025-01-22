//
//  VerificateEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerifyEmailViewController: UIViewController {
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
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifyCodeField.setFocusToFirstField()
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
    }
}


class CodeInputViewController: UIViewController {
    let verifyCodeField = VerifyCodeField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Добавляем его на вью контроллера
        view.backgroundColor = .white
        view.addSubview(verifyCodeField)
        verifyCodeField.translatesAutoresizingMaskIntoConstraints = false
        // Задаём размер и позицию (центрируем вью на экране)
        NSLayoutConstraint.activate([
            verifyCodeField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyCodeField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        //        verifyCodeField.setHeight(50)
        //        verifyCodeField.setWidth(230)
        
        // Слушаем событие "все цифры введены"
        verifyCodeField.onComplete = { code in
            print("Пользователь ввёл код: \(code)")
        }
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        // Теперь даём фокус, когда экран уже отобразился
    //        verifyCodeField.setFocusToFirstField()
    //    }
}
