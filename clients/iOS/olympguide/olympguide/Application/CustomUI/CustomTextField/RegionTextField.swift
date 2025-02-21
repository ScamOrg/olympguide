//
//  RegionTextField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

protocol RegionTextFieldDelegate: AnyObject {
    func regionTextFieldDidSelect(region: Int)
    func regionTextFieldWillSelect(with optionsVC: OptionsViewController)
    func dissmissKeyboard()
}

protocol RegionDelegateOwner: AnyObject {
    var regionDelegate: RegionTextFieldDelegate? { get set }
}

final class RegionTextField: CustomTextField, HighlightableField, RegionDelegateOwner {
    var isWrong: Bool = false
    
    weak var regionDelegate: RegionTextFieldDelegate?
    var selectedIndecies: Set<Int> = []
    private var endPoint: String = ""
    
    init(with title: String, endPoint: String) {
        self.endPoint = endPoint
        super.init(with: title)
        isUserInteractionEnabled(false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
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
    func didSelectOption(_ optionsIndicies: Set<Int>, _ optionsNames: [Options.FetchOptions.ViewModel.OptionViewModel]) {
        selectedIndecies = optionsIndicies
        if optionsIndicies.isEmpty {
            setTextFieldText("")
        } else {
            setTextFieldText(optionsNames[0].name)
            regionDelegate?.regionTextFieldDidSelect(region: optionsNames[0].id)
        }
        textFieldSendAction(for: .editingChanged)
    }
    
    func didCancle() {
        textFieldSendAction(for: .editingChanged)
    }
}
