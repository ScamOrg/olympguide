//
//  BenefitViewController.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class BenefitViewController: UIViewController {
    let viewModel: Benefits.Load.ViewModel.BenefitViewModel
    let informationStackView: UIStackView = UIStackView()
    
    init(with viewModel: Benefits.Load.ViewModel.BenefitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height = informationStackView.frame.height + 20 * 2
        let weight = view.frame.width - 10
        
        self.preferredContentSize = CGSize(width: weight, height: height)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureInformatonStack()
        configureOlympiadTitleLabel()
        configureOlympiadNameLabel()
        configureOlympiadInformation()
        configureBenefitInformationStack()
        configurationConfirmationSubjects()
    }
    
    private func configureInformatonStack() {
        view.addSubview(informationStackView)
        informationStackView.axis = .vertical
        informationStackView.spacing = 17
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        informationStackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        informationStackView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 20)
        informationStackView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 20)
    }
    
    private func configureOlympiadTitleLabel() {
        let olympiadTitleLabel: UILabel = UILabel()
        olympiadTitleLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 20)
        olympiadTitleLabel.textColor = .black
        olympiadTitleLabel.text = "Олимпиада"
        olympiadTitleLabel.textAlignment = .center
        
        informationStackView.addArrangedSubview(olympiadTitleLabel)
        
        olympiadTitleLabel.pinCenterX(to: informationStackView.centerXAnchor)
    }
    
    private func configureOlympiadNameLabel() {
        let nameLabel: UILabel = UILabel()
        nameLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.text = viewModel.olympiadName
        
        informationStackView.addArrangedSubview(nameLabel)
    }
    
    private func configureOlympiadInformation() {
        let olympiadInformationStack = UIStackView()
        
        olympiadInformationStack.axis = .vertical
        olympiadInformationStack.spacing = 7
        olympiadInformationStack.distribution = .fill
        olympiadInformationStack.alignment = .leading
        
        olympiadInformationStack.addArrangedSubview(configureLevelLabel())
        olympiadInformationStack.addArrangedSubview(configureProfileLabel())
        olympiadInformationStack.addArrangedSubview(configureClassLebel())
        
        informationStackView.addArrangedSubview(olympiadInformationStack)
    }
    
    private func configureLevelLabel() -> UILabel {
        let levelLabel: UILabel = UILabel()
        levelLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
        levelLabel.textColor = UIColor(hex: "#787878")
        levelLabel.text = "Уровень: \(String(repeating: "I", count: viewModel.olympiadLevel))"
        
        return levelLabel
    }
    
    private func configureProfileLabel() -> UILabel {
        let profileLabel: UILabel = UILabel()
        profileLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
        profileLabel.textColor = UIColor(hex: "#787878")
        profileLabel.numberOfLines = 0
        profileLabel.lineBreakMode = .byWordWrapping
        profileLabel.text = "Профиль: \(viewModel.olympiadProfile)"
        
        return profileLabel
    }
    
    private func configureClassLebel() -> UILabel {
        let classLabel: UILabel = UILabel()
        classLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
        classLabel.textColor = UIColor(hex: "#787878")
        classLabel.text = "Класс: \(viewModel.minClass)"
        
        return classLabel
    }
    
    private func configureBenefitInformationStack() {
        let benefitInformationStack = UIStackView()
        
        benefitInformationStack.axis = .vertical
        benefitInformationStack.spacing = 7
        benefitInformationStack.distribution = .fill
        benefitInformationStack.alignment = .leading
        
        benefitInformationStack.addArrangedSubview(configureBenefitLabel())
        
        informationStackView.addArrangedSubview(benefitInformationStack)
        
        guard let fullScoreSubjects = viewModel.fullScoreSubjects else { return }
        
        for subject in fullScoreSubjects {
            let subjectLabel: UILabel = UILabel()
            subjectLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
            subjectLabel.textColor = UIColor(hex: "#787878")
            subjectLabel.numberOfLines = 0
            subjectLabel.lineBreakMode = .byWordWrapping
            subjectLabel.text = "• \(subject)"
            benefitInformationStack.addArrangedSubview(subjectLabel)
        }
    }
    
    private func configureBenefitLabel() -> UILabel {
        let benefitLabel: UILabel = UILabel()
        benefitLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        benefitLabel.textColor = .black
        benefitLabel.numberOfLines = 0
        benefitLabel.lineBreakMode = .byWordWrapping
        
        let benefitText = viewModel.isBVI ? "БВИ" : "100 баллов за ЕГЭ по одному из следующих предметов:"
        
        benefitLabel.text = "Льгота: \(benefitText)"
        
        return benefitLabel
    }
    
    private func configurationConfirmationSubjects() {
        guard
            let confirmationSubjects = viewModel.confirmationSubjects,
                confirmationSubjects.count > 0
        else { return }

        let subjectsStackView: UIStackView = UIStackView()
        subjectsStackView.axis = .vertical
        subjectsStackView.spacing = 7
        subjectsStackView.distribution = .fill
        subjectsStackView.alignment = .leading
        
        subjectsStackView.addArrangedSubview(configureConfirmationLabel(score: confirmationSubjects[0].score))
        
        for subject in confirmationSubjects {
            let subjectLabel: UILabel = UILabel()
            subjectLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
            subjectLabel.textColor = UIColor(hex: "#787878")
            subjectLabel.numberOfLines = 0
            subjectLabel.lineBreakMode = .byWordWrapping
            subjectLabel.text = "• \(subject.subject)"
            subjectsStackView.addArrangedSubview(subjectLabel)
        }
        
        informationStackView.addArrangedSubview(subjectsStackView)
    }
    
    private func configureConfirmationLabel(score: Int) -> UILabel {
        let confirmationLabel: UILabel = UILabel()
        confirmationLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        confirmationLabel.textColor = .black
        confirmationLabel.numberOfLines = 0
        confirmationLabel.lineBreakMode = .byWordWrapping
        
        confirmationLabel.text = "Для подтверждения олимпиады необходимо сдать ЕГЭ на \(score) баллов по одному из следующих предметов:"
        
        return confirmationLabel
    }
}
