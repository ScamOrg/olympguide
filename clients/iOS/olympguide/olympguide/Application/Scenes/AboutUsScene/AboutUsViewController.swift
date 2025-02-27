//
//  AboutUsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit
import SafariServices

final class AboutUsViewController : UIViewController {
    let informationStackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        
        configureInformationStack()
        configureAboutUsLabel()
        configureContactButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "О нас"
    }
    
    private func configureInformationStack() {
        informationStackView.axis = .vertical
        informationStackView.spacing = 20
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        view.addSubview(informationStackView)
        
        informationStackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        informationStackView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 20)
        informationStackView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 20)
    }
    
    private func configureAboutUsLabel() {
        let aboutUsLabel: UILabel = UILabel()
        aboutUsLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        aboutUsLabel.textColor = .black
        aboutUsLabel.numberOfLines = 0
        aboutUsLabel.lineBreakMode = .byWordWrapping
        
        aboutUsLabel.text = "Если вы одинокая красивая девушка в возрасте от 17 до 20 лет, то напишите CEO данной компании Арсению Титаренко в телеграмм"
        
        informationStackView.addArrangedSubview(aboutUsLabel)
    }
    
    private func configureContactButton() {
        let contactButton: UIButton = UIButton()
        contactButton.setTitle("@easyeeeye", for: .normal)
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        
        contactButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
        
        informationStackView.addArrangedSubview(contactButton)
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard let contact = sender.currentTitle else { return }
        let realContact = contact.replacingOccurrences(of: "@", with: "")
        guard let url = URL(string: "https://t.me/\(realContact)") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
}
