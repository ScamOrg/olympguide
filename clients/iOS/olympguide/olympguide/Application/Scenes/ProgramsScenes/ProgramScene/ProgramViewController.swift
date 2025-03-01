//
//  ProgramViewController.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit
import SafariServices
import Combine

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

final class ProgramViewController : UIViewController, WithBookMarkButton {
    var interactor: (ProgramBusinessLogic & BenefitsBusinessLogic)?
    var router: (ProgramRoutingLogic & BenefitsRoutingLogic)?
    
    private var cancellables = Set<AnyCancellable>()
    
    let logoImageView: UIImageViewWithShimmer = UIImageViewWithShimmer(frame: .zero)
    var startIsFavorite: Bool
    var isFavorite: Bool
    let universityNameLabel: UILabel = UILabel()
    let regionLabel: UILabel = UILabel()
    let logo: String
    let university: UniversityModel
    let codeLabel: UILabel = UILabel()
    let programNameLabel = UILabel()
    let program: GroupOfProgramsModel.ProgramModel
    var benefits: [Benefits.Load.ViewModel.BenefitViewModel] = []
    var link: String? = nil
    
    private let informationContainer: UIView = UIView()
    private let budgtetLabel: UIInformationLabel = UIInformationLabel()
    private let paidLabel: UIInformationLabel = UIInformationLabel()
    private let costLabel: UIInformationLabel = UIInformationLabel()
    private let subjectsStack: SubjectsStack = SubjectsStack()
    private let webSiteButton: UIInformationButton = UIInformationButton(type: .web)
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init (
        for program: ProgramModel
    ) {
        self.logo = program.university.logo
        self.isFavorite = program.like
        self.startIsFavorite = program.like
        
        self.university = program.university
        self.program = GroupOfProgramsModel.ProgramModel(
            programID: program.programID,
            name: program.name,
            field: program.field,
            budgetPlaces: program.budgetPlaces,
            paidPlaces: program.paidPlaces,
            cost: program.cost,
            requiredSubjects: program.requiredSubjects,
            optionalSubjects: program.optionalSubjects,
            like: program.like
        )
        
        if var link = program.link {
            link = link.replacingOccurrences(of: "https://www.", with: "")
                .replacingOccurrences(of: "https://", with: "")
            self.webSiteButton.setTitle(link, for: .normal)
            self.link = link
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        for program: GroupOfProgramsModel.ProgramModel,
        by university: UniversityModel
    ) {
        self.logo = university.logo
        self.isFavorite = program.like
        self.startIsFavorite = program.like
        self.university = university
        self.program = program
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBindings()
        
        ImageLoader.shared.loadImage(from: logo) { [weak self] (image: UIImage?) in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
        
        let benefitRequest = Benefits.Load.Request(programID: program.programID)
        interactor?.loadBenefits(with: benefitRequest)
        
        if webSiteButton.titleLabel?.text == nil {
            let programRequest = Program.Load.Request(programID: program.programID)
            interactor?.loadProgram(with: programRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        navigationController.bookMarkButtonPressed = {[weak self] sender in
            self?.isFavorite.toggle()
            let newImageName = self?.isFavorite ?? false ? "bookmark.fill" :  "bookmark"
            sender.setImage(UIImage(systemName: newImageName), for: .normal)
            
            guard let self = self else { return }
            
            if self.isFavorite {
                let model = ProgramModel(
                    programID: program.programID,
                    name: program.name,
                    field: program.field,
                    budgetPlaces: program.budgetPlaces,
                    paidPlaces: program.paidPlaces,
                    cost: program.cost,
                    requiredSubjects: program.requiredSubjects,
                    optionalSubjects: program.optionalSubjects ?? [],
                    like: true,
                    university: university,
                    link: self.link
                )
                
                FavoritesManager.shared.addProgramToFavorites(viewModel: model)
            } else {
                FavoritesManager.shared.removeProgramFromFavorites(programID: program.programID)
            }
        }
    }
}

// MARK: - UI Configuration
extension ProgramViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureLogoImageView()
        configureRegionLabel()
        configureUniversityNameLabel()
        configureCodeLabel()
        configureProgramNameLabel()
        configureWebButton()
        configureBudgetLabel()
        configurePaidLabel()
        configureCostLabel()
        configureSubjectsStack()
        
        configureRefreshControl()
        configureTableView()
        
        reloadFavoriteButton()
        
        logoImageView.startShimmer()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureLogoImageView() {
        informationContainer.addSubview(logoImageView)
        
        logoImageView.contentMode = .scaleAspectFit
        
        logoImageView.pinLeft(to: informationContainer.leadingAnchor, Constants.Dimensions.logoLeftMargin)
        logoImageView.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        logoImageView.setWidth(Constants.Dimensions.logoSize)
        logoImageView.setHeight(Constants.Dimensions.logoSize)
    }
    
    private func configureRegionLabel() {
        regionLabel.font = Constants.Fonts.regionLabelFont
        regionLabel.textColor = Constants.Colors.regionTextColor
        regionLabel.text = university.region
        
        informationContainer.addSubview(regionLabel)
        
        regionLabel.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureUniversityNameLabel() {
        universityNameLabel.font = Constants.Fonts.nameLabelFont
        universityNameLabel.numberOfLines = 0
        universityNameLabel.lineBreakMode = .byWordWrapping
        universityNameLabel.text = university.name
        
        informationContainer.addSubview(universityNameLabel)

        universityNameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        universityNameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        universityNameLabel.pinRight(to: informationContainer.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureCodeLabel() {
        codeLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
        codeLabel.text = program.field
        
        informationContainer.addSubview(codeLabel)
        codeLabel.pinTop(to: logoImageView.bottomAnchor, 30, .grOE)
//        codeLabel.pinTop(to: universityNameLabel.bottomAnchor, 30, .grOE)
        codeLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configureProgramNameLabel() {
        programNameLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        programNameLabel.numberOfLines = 0
        programNameLabel.lineBreakMode = .byWordWrapping
        programNameLabel.text = program.name
        
        informationContainer.addSubview(programNameLabel)
        programNameLabel.pinTop(to: codeLabel.bottomAnchor, 5)
        programNameLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
        programNameLabel.pinRight(to: informationContainer.trailingAnchor, 20)
    }
    
    private func configureWebButton() {
        informationContainer.addSubview(webSiteButton)
        
        webSiteButton.pinTop(to: programNameLabel.bottomAnchor, 5)
        webSiteButton.pinLeft(to: informationContainer.leadingAnchor, 20)
        webSiteButton.pinRight(to: informationContainer.trailingAnchor, 20)
        
        webSiteButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
    }
    
    private func configureBudgetLabel() {
        budgtetLabel.setText(regular: "Бюджетных мест  ", bold: String(program.budgetPlaces))
        
        informationContainer.addSubview(budgtetLabel)
        
        budgtetLabel.pinTop(to: webSiteButton.bottomAnchor, 11)
        budgtetLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configurePaidLabel() {
        paidLabel.setText(regular: "Платных мест  ", bold: String(program.paidPlaces))
        
        informationContainer.addSubview(paidLabel)
        
        paidLabel.pinTop(to: budgtetLabel.bottomAnchor, 7)
        paidLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configureCostLabel() {
        costLabel.setText(regular: "Стоимость  ", bold: formatNumber(program.cost))
        
        informationContainer.addSubview(costLabel)
        
        costLabel.pinTop(to: paidLabel.bottomAnchor, 7)
        costLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configureSubjectsStack() {
        subjectsStack.configure(
            requiredSubjects: program.requiredSubjects,
            optionalSubjects: program.optionalSubjects ?? []
        )
        
        informationContainer.addSubview(subjectsStack)
        
        subjectsStack.pinTop(to: costLabel.bottomAnchor, 11)
        subjectsStack.pinLeft(to: informationContainer.leadingAnchor, 20)
        subjectsStack.pinBottom(to: informationContainer.bottomAnchor)
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return "\(formatter.string(from: NSNumber(value: number)) ?? "\(number)") ₽/год"
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        informationContainer.setNeedsLayout()
        informationContainer.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = informationContainer.systemLayoutSizeFitting(targetSize)
        informationContainer.frame.size.height = fittingSize.height
        tableView.tableHeaderView = informationContainer
        
        tableView.tableHeaderView = informationContainer
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let programID = self?.program.programID else { return }
            let request = Benefits.Load.Request(programID: programID)
            
            self?.interactor?.loadBenefits(with: request)
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard let contact = sender.currentTitle else { return }
        let realContact = contact.replacingOccurrences(of: "@", with: "")
        guard let url = URL(string: "https://\(realContact)") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProgramViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        benefits.count != 0 ? benefits.count : 10
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: OlympiadTableViewCell.identifier,
            for: indexPath
        ) as! OlympiadTableViewCell
        
        if benefits.count != 0 {
            let benefitModel = benefits[indexPath.row]
            cell.configure(with: benefitModel)
        } else {
            cell.configureShimmer()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProgramViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = BenefitViewController(with: benefits[indexPath.row])
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
        }
        present(detailVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(
      _ tableView: UITableView,
      contextMenuConfigurationForRowAt indexPath: IndexPath,
      point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let detailVC = BenefitViewController(with: self.benefits[indexPath.row])
                return detailVC
            },
            actionProvider: { _ in
                return UIMenu(title: "", children: [
                ])
            }
        )
    }
}

// MARK: - BenefitsDisplayLogic
extension ProgramViewController : BenefitsDisplayLogic {
    func displayLoadBenefitsResult(with viewModel: Benefits.Load.ViewModel) {
        benefits = viewModel.benefits
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - ProgramDisplayLogic
extension ProgramViewController : ProgramDisplayLogic {
    func displayLoadProgram(with viewModel: Program.Load.ViewModel) {
        let link = viewModel.link
            .replacingOccurrences(of: "https://www.", with: "")
            .replacingOccurrences(of: "https://", with: "")
        webSiteButton.setTitle(link, for: .normal)
        self.link = link
    }
    
    func displayToggleFavoriteResult(viewModel: Program.Favorite.ViewModel) {
        
    }
}

// MARK: - Combine
extension ProgramViewController {
    private func setupBindings() {
        FavoritesManager.shared.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case.added(let program):
                    if program.programID == self.program.programID {
                        self.isFavorite = true
                    }
                case .removed(let programID):
                    if programID == self.program.programID {
                        self.isFavorite = false
                    }
                case .error(let programID):
                    if programID == self.program.programID {
                        self.isFavorite = self.startIsFavorite
                    }
                case .access(let programID, let isFavorite):
                    if programID == self.program.programID {
                        self.startIsFavorite = isFavorite
                    }
                }
                reloadFavoriteButton()
            }.store(in: &cancellables)
    }
    
    private func reloadFavoriteButton() {
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
}

