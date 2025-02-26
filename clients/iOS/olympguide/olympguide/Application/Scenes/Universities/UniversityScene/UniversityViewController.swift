//
//  UniversityViewController.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit
import SafariServices
import MessageUI

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

protocol WithBookMarkButton { }

final class UniversityViewController: UIViewController, WithBookMarkButton {
    var interactor: (UniversityBusinessLogic & ProgramsBusinessLogic)?
    
    var router: (UniversityRoutingLogic & ProgramsRoutingLogic)?
    
    let informationContainer: UIView = UIView()
    let logoImageView: UIImageViewWithShimmer = UIImageViewWithShimmer(frame: .zero)
    let universityID: Int
    let startIsFavorite: Bool
    var isFavorite: Bool
    let nameLabel: UILabel = UILabel()
    let regionLabel: UILabel = UILabel()
    let logo: String
    let webSiteButton: UIInformationButton = UIInformationButton(type: .web)
    let emailButton: UIInformationButton = UIInformationButton(type: .email)
    let university: UniversityModel
    let programsLabel: UILabel = UILabel()
    let segmentedControl: UISegmentedControl = UISegmentedControl()
    let filterSortView: FilterSortView = FilterSortView()
    
    private var groupOfProgramsViewModel : [Programs.Load.ViewModel.GroupOfProgramsViewModel] = []
    
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    init(for university: UniversityModel) {
        self.logoImageView.contentMode = .scaleAspectFit
        self.logo = university.logo
        self.universityID = university.universityID
        self.isFavorite = university.like
        self.startIsFavorite = university.like
        self.university = university
        
        super.init(nibName: nil, bundle: nil)
        
        self.nameLabel.text = university.name
        self.regionLabel.text = university.region
        self.title = university.shortName
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        logoImageView.startShimmer()
        webSiteButton.startShimmer()
        ImageLoader.shared.loadImage(from: logo) { [weak self] (image: UIImage?) in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
        
        interactor?.loadUniversity(with: University.Load.Request(universityID: universityID))
        
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if startIsFavorite != isFavorite {
            let request = University.Favorite.Request(
                universityID: universityID,
                isFavorite: isFavorite
            )
            interactor?.toggleFavorite(with: request)
        }
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureLogoImageView()
        configureRegionLabel()
        configureNameLabel()
        configureWebSiteButton()
        configureEmailButton()
        configureProgramsLabel()
        configureSearchButton()
        configureSegmentedControl()
        
        configureRefreshControl()
        configureTableView()
        
        logoImageView.startShimmer()
        webSiteButton.startShimmer()
        emailButton.startShimmer()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
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
        informationContainer.addSubview(logoImageView)
        
        logoImageView.contentMode = .scaleAspectFit
        
        regionLabel.font = Constants.Fonts.regionLabelFont
        regionLabel.textColor = Constants.Colors.regionTextColor
        
        logoImageView.pinLeft(to: informationContainer.leadingAnchor, Constants.Dimensions.logoLeftMargin)
        logoImageView.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        logoImageView.setWidth(Constants.Dimensions.logoSize)
        logoImageView.setHeight(Constants.Dimensions.logoSize)
    }
    
    private func configureRegionLabel() {
        informationContainer.addSubview(regionLabel)
        
        regionLabel.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureNameLabel() {
        informationContainer.addSubview(nameLabel)
        
        nameLabel.font = Constants.Fonts.nameLabelFont
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        nameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        nameLabel.pinRight(to: informationContainer.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureWebSiteButton() {
        informationContainer.addSubview(webSiteButton)
        
        webSiteButton.pinTop(to: logoImageView.bottomAnchor, 30, .grOE)
        webSiteButton.pinTop(to: nameLabel.bottomAnchor, 30)
        webSiteButton.pinLeft(to: informationContainer.leadingAnchor, 20)
        webSiteButton.pinRight(to: informationContainer.centerXAnchor)
        webSiteButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
    }
    
    private func configureEmailButton() {
        informationContainer.addSubview(emailButton)
        
        emailButton.pinTop(to: webSiteButton.bottomAnchor, 20)
        emailButton.pinLeft(to: informationContainer.leadingAnchor, 20)
        emailButton.pinRight(to: informationContainer.centerXAnchor)
        emailButton.addTarget(self, action: #selector(openMailCompose), for: .touchUpInside)
    }
    
    private func configureProgramsLabel() {
        let text = "Программы"
        let font = UIFont(name: "MontserratAlternates-SemiBold", size: 20)!
        programsLabel.text = text
        programsLabel.font = font
        
        informationContainer.addSubview(programsLabel)
        programsLabel.pinTop(to: emailButton.bottomAnchor, 20)
        programsLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
        
        let textSize = text.size(withAttributes: [.font: font])
        
        programsLabel.setHeight(textSize.height)
    }
    
    private func configureSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "По направлениям", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "По факультетам", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        let customFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        let customAttributes: [NSAttributedString.Key: Any] = [.font: customFont]

        segmentedControl.setTitleTextAttributes(customAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(customAttributes, for: .selected)
        
        
        informationContainer.addSubview(segmentedControl)
        
        segmentedControl.pinTop(to: programsLabel.bottomAnchor, 13)
        segmentedControl.pinLeft(to: informationContainer.leadingAnchor, 20)
        segmentedControl.pinRight(to: informationContainer.trailingAnchor, 20)
        segmentedControl.pinBottom(to: informationContainer.bottomAnchor, 17)
        segmentedControl.setHeight(35)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func configureSearchButton() {
        let searchButton = UIClosureButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.contentHorizontalAlignment = .fill
        searchButton.contentVerticalAlignment = .fill
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.action = { [weak self] in
            self?.router?.routeToSearch()
        }
        
        informationContainer.addSubview(searchButton)
        
        searchButton.pinRight(to: informationContainer.trailingAnchor, 20)
        searchButton.pinCenterY(to: programsLabel.centerYAnchor)
        
        searchButton.setWidth(28)
        searchButton.setHeight(28)
    }
    
    private func configureFilterSortView() {
        filterSortView.configure(filteringOptions: ["Формат обучения"])
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard let url = URL(string: "https://\(sender.currentTitle ?? "")") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc func segmentChanged() {
        var request = Programs.Load.Request(
            params: [],
            university: university
        )
        if segmentedControl.selectedSegmentIndex == 1 {
            request.groups = .faculties
        }
        
        interactor?.loadPrograms(with: request)
    }
}

extension UniversityViewController : UniversityDisplayLogic {
    func displayToggleFavoriteResult(with viewModel: University.Favorite.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "Не удалось добавить ВУЗ в изранные" , with: viewModel.errorMessage)
        }
    }
    
    func displayLoadResult(with viewModel: University.Load.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.webSiteButton.setTitle(viewModel.site, for: .normal)
            self?.emailButton.setTitle(viewModel.email, for: .normal)
        }
    }
}

extension UniversityViewController : MFMailComposeViewControllerDelegate{
    @objc func openMailCompose(sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert(
                with: "На телефоне нет настроенного клиента для отправки электронной почты",
                cancelTitle: "Ок"
            )
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([sender.currentTitle ?? ""])
        mailVC.setSubject("Вопрос по поступлению")
        mailVC.setMessageBody("Здравствуйте!", isHTML: false)
        
        present(mailVC, animated: true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UniversityViewController : UITableViewDataSource {
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        
        tableView.pinTop(to: emailButton.bottomAnchor, 12)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)

        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupOfProgramsViewModel.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return groupOfProgramsViewModel[section].isExpanded ? groupOfProgramsViewModel[section].programs.count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier,
            for: indexPath
        ) as! ProgramTableViewCell
        
        let fieldViewModel = groupOfProgramsViewModel[indexPath.section].programs[indexPath.row]
        cell.configure(with: fieldViewModel)
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        let isLastCell = indexPath.row == totalRows - 1
        
        if isLastCell {
            cell.hideSeparator()
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerButton = FieldsTableButton(name: groupOfProgramsViewModel[section].name, code: groupOfProgramsViewModel[section].code)
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        
        if groupOfProgramsViewModel[section].isExpanded {
            headerButton.backgroundView.backgroundColor = UIColor(hex: "#E0E8FE")
        }
        return headerButton
    }
    
        
        
    }
    
}

