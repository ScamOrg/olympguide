//
//  ProgramViewController.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

fileprivate enum Constants {
    enum Dimensions {
        static let logoTopMargin: CGFloat = 30
        static let logoLeftMargin: CGFloat = 15
        static let logoSize: CGFloat = 80
        static let interItemSpacing: CGFloat = 20
        static let nameLabelBottomMargin: CGFloat = 20
        static let favoriteButtonSize: CGFloat = 22
        static let separatorHeight: CGFloat = 1
        static let separatorHorizontalInset: CGFloat = 20
    }
    
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
        static let regionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
    }
    
    enum Fonts {
        static let nameLabelFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        static let regionLabelFont = UIFont(name: "MontserratAlternates-Regular", size: 13)!
    }
}

final class ProgramViewController : UIViewController {
    let logoImageView: UIImageViewWithShimmer = UIImageViewWithShimmer(frame: .zero)
    let startIsFavorite: Bool
    var isFavorite: Bool
    let universityNameLabel: UILabel = UILabel()
    let regionLabel: UILabel = UILabel()
    let logo: String
    let university: UniversityModel
    let codeLabel: UILabel = UILabel()
    let programNameLabel = UILabel()
    let program: Programs.Load.ViewModel.GroupOfProgramsViewModel.ProgramViewModel
    
    private let budgtetLabel: UIInformationLabel = UIInformationLabel()
    private let paidLabel: UIInformationLabel = UIInformationLabel()
    private let costLabel: UIInformationLabel = UIInformationLabel()
    private let subjectsStack: SubjectsStack = SubjectsStack()
    
    init(
        for program: Programs.Load.ViewModel.GroupOfProgramsViewModel.ProgramViewModel,
        by university: UniversityModel
    ) {
        self.logoImageView.contentMode = .scaleAspectFit
        self.logo = university.logo
        self.isFavorite = university.like
        self.startIsFavorite = university.like
        self.university = university
        self.codeLabel.text = program.code
        self.programNameLabel.text = program.name
        self.program = program
        
        super.init(nibName: nil, bundle: nil)
        
        self.universityNameLabel.text = university.name
        self.regionLabel.text = university.region
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        ImageLoader.shared.loadImage(from: logo) { [weak self] (image: UIImage?) in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureLogoImageView()
        configureRegionLabel()
        configureUniversityNameLabel()
        configureCodeLabel()
        configureProgramNameLabel()
        configureBudgetLabel()
        configurePaidLabel()
        configureCostLabel()
        configureSubjectsStack()
        
        logoImageView.startShimmer()
    }
    
    private func configureNavigationBar() {
        if let navigationController = navigationController as? NavigationBarViewController {
            let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
            navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
            navigationController.bookMarkButtonPressed = {[weak self] sender in
                self?.isFavorite.toggle()
                let newImageName = self?.isFavorite ?? false ? "bookmark.fill" :  "bookmark"
                sender.setImage(UIImage(systemName: newImageName), for: .normal)
            }
        }
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        
        logoImageView.contentMode = .scaleAspectFit
        
        regionLabel.font = Constants.Fonts.regionLabelFont
        regionLabel.textColor = Constants.Colors.regionTextColor
        
        logoImageView.pinLeft(to: view.leadingAnchor, Constants.Dimensions.logoLeftMargin)
        logoImageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        logoImageView.setWidth(Constants.Dimensions.logoSize)
        logoImageView.setHeight(Constants.Dimensions.logoSize)
    }
    
    private func configureRegionLabel() {
        view.addSubview(regionLabel)
        
        regionLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureUniversityNameLabel() {
        view.addSubview(universityNameLabel)
        
        universityNameLabel.font = Constants.Fonts.nameLabelFont
        universityNameLabel.numberOfLines = 0
        universityNameLabel.lineBreakMode = .byWordWrapping
        
        universityNameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        universityNameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        universityNameLabel.pinRight(to: view.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureCodeLabel() {
        codeLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
        
        view.addSubview(codeLabel)
        codeLabel.pinTop(to: logoImageView.bottomAnchor, 30, .grOE)
        codeLabel.pinTop(to: universityNameLabel.bottomAnchor, 30)
        codeLabel.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureProgramNameLabel() {
        programNameLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        
        view.addSubview(programNameLabel)
        programNameLabel.pinTop(to: codeLabel.bottomAnchor, 10)
        programNameLabel.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureBudgetLabel() {
        budgtetLabel.setText(regular: "Бюджетных мест  ", bold: String(program.budgetPlaces))
        
        view.addSubview(budgtetLabel)
        
        budgtetLabel.pinTop(to: programNameLabel.bottomAnchor, 11)
        budgtetLabel.pinLeft(to: view.leadingAnchor, 40)
    }
    
    private func configurePaidLabel() {
        paidLabel.setText(regular: "Платных мест  ", bold: String(program.paidPlaces))
        
        view.addSubview(paidLabel)
        
        paidLabel.pinTop(to: budgtetLabel.bottomAnchor, 7)
        paidLabel.pinLeft(to: view.leadingAnchor, 40)
    }
    
    private func configureCostLabel() {
        costLabel.setText(regular: "Стоимость  ", bold: formatNumber(program.cost))
        
        view.addSubview(costLabel)
        
        costLabel.pinTop(to: paidLabel.bottomAnchor, 7)
        costLabel.pinLeft(to: view.leadingAnchor, 40)
    }
    
    private func configureSubjectsStack() {
        subjectsStack.configure(
            requiredSubjects: program.requiredSubjects,
            optionalSubjects: program.optionalSubjects ?? []
        )
        
        view.addSubview(subjectsStack)
        
        subjectsStack.pinTop(to: costLabel.bottomAnchor, 11)
        subjectsStack.pinLeft(to: view.leadingAnchor, 40)
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return "\(formatter.string(from: NSNumber(value: number)) ?? "\(number)") ₽/год"
    }
}
