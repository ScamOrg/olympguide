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
    
    @objc func openWebPage(sender: UIButton) {
        guard let url = URL(string: "https://\(sender.currentTitle ?? "")") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTableViewCell()
        switch indexPath.row {
        case 0:
            cell.configure(title: "Направления")
        case 1:
            cell.configure(title: "Факультеты")
            cell.hideSeparator(true)
        default:
            break
        }
        return cell
    }
}

extension UniversityViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            router?.routeToProgramsByFields(for: university)
        case 1:
            router?.routeToProgramsByFaculties(for: university)
        default:
            break
        }
    }
}

import SwiftUI


struct UniversityViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let sampleUniversity = UniversityModel(
            email: nil,
            site: nil,
            description: nil,
            phone: nil,
            universityID: 1,
            name: "Национальный исследовательский университет «Высшая школа экономики»",
            shortName: "ВШЭ",
            logo: "https://drive.google.com/uc?export=download&id=1UIXzJTDYv2ys_Bq5n_EPiQrRBhfujq1k",
            region: "Москва и Московскя область",
            like: true
        )
        
        let universityVC = UniversityViewController(for: sampleUniversity)
        
        let navigationController = NavigationBarViewController(rootViewController: universityVC)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

