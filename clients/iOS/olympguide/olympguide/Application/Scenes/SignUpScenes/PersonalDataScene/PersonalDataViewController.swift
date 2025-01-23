//
//  PersonalDataScene.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit

final class PersonalDataViewController: UIViewController {
    private var userEmail: String = ""
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.userEmail = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let lastNameTextField: CustomSearchBar = CustomSearchBar(with: "Фамилия")
    let nameTextField: CustomSearchBar = CustomSearchBar(with: "Имя")
    let secondNameTextField: CustomSearchBar = CustomSearchBar(with: "Отчество")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Личные данные"
        configureUI()
    }
    
    private func configureUI() {
        configureLastNameTextField()
        configureNameTextField()
        configureSecondNameTextField()
    }
    
    private func configureLastNameTextField() {
        view.addSubview(lastNameTextField)
        lastNameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        lastNameTextField.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.pinTop(to: lastNameTextField.bottomAnchor, 24)
        nameTextField.pinLeft(to: view.leadingAnchor, 20)
    }
        
    private func configureSecondNameTextField() {
        view.addSubview(secondNameTextField)
        secondNameTextField.pinTop(to: nameTextField.bottomAnchor, 24)
        secondNameTextField.pinLeft(to: view.leadingAnchor, 20)
    }
    
}
