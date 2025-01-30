//
//  RegionTextField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

protocol RegionTextFieldDelegate: AnyObject {
    func regionTextFieldDidSelect(region: String)
    func regionTextFieldWillSelect(with optionsVC: OptionsViewController)
    func dissmissKeyboard()
}

final class RegionTextField: CustomTextField {
    weak var regionDelegate: RegionTextFieldDelegate?
    var regions: [String] = []
    var optionVC: OptionsViewController
    init(with title: String, regions: [String]) {
        optionVC = OptionsViewController(items: regions,
                                         title: "Регион",
                                         isMultipleChoice: false)
        self.regions = regions
        super.init(with: title)
        optionVC.delegate = self
        isUserInteractionEnabled(false)
    }
    
    @MainActor required init?(coder: NSCoder) {
        optionVC = OptionsViewController(items: regions,
                                         title: "Сортировка",
                                         isMultipleChoice: false)
        super.init(coder: coder)
        optionVC.delegate = self
    }
    
    override func didTapSearchBar() {
        let hasText = isEmty()
        guard !hasText else { return }
        
        regionDelegate?.dissmissKeyboard()
        isActive.toggle()
        updateAppereance()
        if isActive{
            presentOptions()
        }
    }
    
    private func presentOptions() {
        regionDelegate?.regionTextFieldWillSelect(with: optionVC)
    }
    
}

extension RegionTextField : OptionsViewControllerDelegate {
    func didSelectOption(_ options: [Int]) {
        guard !options.isEmpty else { return }
        setTextFieldText(regions[options[0]])
        textFieldSendAction(for: .editingChanged)
    }
    
    func didCancle() {
        textFieldSendAction(for: .editingChanged)
    }
}
