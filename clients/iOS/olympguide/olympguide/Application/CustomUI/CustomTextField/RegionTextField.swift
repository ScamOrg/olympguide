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
    var selectedIndecies: Set<Int> = []
    private var endPoint: String = ""
    
    init(with title: String, endPoint: String) {
        self.endPoint = endPoint
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
            title: "Регион",
            isMultipleChoice: false,
            selectedIndices: selectedIndecies,
            count: 87,
            endPoint: endPoint
        )
        optionVC.delegate = self
        regionDelegate?.regionTextFieldWillSelect(with: optionVC)
    }
    
}

extension RegionTextField : OptionsViewControllerDelegate {
    func didSelectOption(_ optionsIndicies: [Int], _ optionsNames: [String]) {
        selectedIndecies = Set(optionsIndicies)
        if optionsIndicies.isEmpty {
            setTextFieldText("")
        } else {
            setTextFieldText(optionsNames[0])
        }
        textFieldSendAction(for: .editingChanged)
    }
    
    func didCancle() {
        textFieldSendAction(for: .editingChanged)
    }
}
