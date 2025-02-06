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
    var regions: [Option] = []
    var selectedIndecies: Set<Int> = []
    init(with title: String, regions: [Option]) {
        self.regions = regions
        super.init(with: title)
        isUserInteractionEnabled(false)
    }
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didTapDeleteButton() {
        super.didTapDeleteButton()
        selectedIndecies = []
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
        let optionVC = OptionsViewController(
            items: regions,
            title: "Регион",
            isMultipleChoice: false,
            selectedIndices: selectedIndecies
        )
        optionVC.delegate = self
        regionDelegate?.regionTextFieldWillSelect(with: optionVC)
    }
    
}

extension RegionTextField : OptionsViewControllerDelegate {
    func didSelectOption(_ options: [Int]) {
        selectedIndecies = Set(options)
        if options.isEmpty {
            setTextFieldText("")
        } else {
            setTextFieldText(regions[options[0]].name)
        }
        textFieldSendAction(for: .editingChanged)
    }
    
    func didCancle() {
        textFieldSendAction(for: .editingChanged)
    }
}
