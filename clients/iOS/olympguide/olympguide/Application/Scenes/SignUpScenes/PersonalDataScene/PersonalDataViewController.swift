//
//  PersonalDataScene.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit

final class PersonalDataViewController: UIViewController {
    private var userEmail: String = ""
    
    let lastNameTextField: CustomSearchBar = CustomSearchBar(with: "Фамилия")
    let nameTextField: CustomSearchBar = CustomSearchBar(with: "Имя")
    let secondNameTextField: CustomSearchBar = CustomSearchBar(with: "Отчество")
    let birthdayPicker: CustomDatePicker = CustomDatePicker(with: "День рождения")
    let regionTextField: CustomSearchBar = CustomSearchBar(with: "Регион")
    
    var lastName = ""
    var name = ""
    var secondName = ""
    var birthday = ""
    var region = ""
    var password = ""
    var confirmPassword = ""
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.userEmail = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.tag = 1
        secondNameTextField.tag = 2
        lastNameTextField.tag = 3
        view.backgroundColor = .white
        title = "Личные данные"
        configureUI()
    }
    
    private func configureUI() {
        configureLastNameTextField()
        configureNameTextField()
        configureSecondNameTextField()
        configureBirthdayPicker()
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
    
    private func configureBirthdayPicker() {
        view.addSubview(birthdayPicker)
        birthdayPicker.pinTop(to: secondNameTextField.bottomAnchor, 24)
        birthdayPicker.pinLeft(to: view.leadingAnchor, 20)
    }
}

extension PersonalDataViewController : CustomTextFieldDelegate {
    func customSearchBar(_ searchBar: CustomTextField, textDidChange text: String) {
        switch searchBar.tag {
        case 1:
            name = text
        case 2:
            secondName = text
        case 3:
            lastName = text
        default:
            break
        }
    }
    
    
}
