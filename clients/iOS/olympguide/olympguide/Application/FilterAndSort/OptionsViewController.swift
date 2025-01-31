//
//  SortOptionsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

protocol OptionsViewControllerDelegate: AnyObject {
    func didSelectOption(_ options: [Int])
    func didCancle()
}

final class OptionsViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OptionsViewControllerDelegate?
    
    var interactor: (OptionsDataStore & OptionsBusinessLogic)?
    
    private var items: [OptionModel] = []
    private var currentItems: [OptionModel] = []
    
    private let dimmingView = UIView()
    private let containerView = UIView()
    private var panGesture: UIPanGestureRecognizer!
    private var finalY: CGFloat = 0
    private var initialSelectedIndices: Set<Int> = []
    var selectedIndices: Set<Int> = []
    private var currentSelectedIndices: Set<Int> = []
    
    private var currentToAll: [Int: Int] = [:]
    private var allToCurrent: [Int: Int] = [:]
    
    private let peak: UIView = UIView()
    
    private let titleLabel: UILabel = UILabel()
    
    private let cancelButton: UIButton = UIButton()
    private let saveButton: UIButton = UIButton()
    
    
    
    private var isMultipleChoice: Bool
    lazy var searchBar: CustomTextField = CustomTextField(with: "Поиск")
    
    private let tableView: UITableView = UITableView()
    
    init(items: [String], title: String, isMultipleChoice: Bool) {
        for (index, value) in items.enumerated() {
            let option = OptionModel(
                title: value,
                realIndex: index,
                currentIndex: index
            )
            self.items.append(option)
        }
        self.titleLabel.text = title
        self.isMultipleChoice = isMultipleChoice
        super.init(nibName: nil, bundle: nil)
        self.currentItems = self.items
        self.currentSelectedIndices = self.selectedIndices
    }
    
    init(items: [String], title: String, isMultipleChoice: Bool, selectedIndices: Set<Int>) {
        for (index, value) in items.enumerated() {
            let option = OptionModel(
                title: value,
                realIndex: index,
                currentIndex: index
            )
            self.items.append(option)
        }
        
        self.titleLabel.text = title
        self.isMultipleChoice = isMultipleChoice
        
        super.init(nibName: nil, bundle: nil)
        
        self.currentItems = self.items
        self.selectedIndices = selectedIndices
        self.currentSelectedIndices = self.selectedIndices
        
        for index in selectedIndices {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        for i in 0..<items.count {
            currentToAll[i] = i
            allToCurrent[i] = i
        }
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen
        configureGesture()
        configureUI()
    }
    
    func setup() {
        let viewController = self
        let interactor = OptionsViewInteractor()
        let presenter = OptionViewPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.items = items
    }
        
    // MARK: - Pan gesture setting (to pull the curtain down)
    private func configureGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        containerView.addGestureRecognizer(panGesture)
    }
    
    private func configureUI() {
        configureDimmingView()
        configureContainerView()
        configurePeak()
        configureTitleLabel()
        configureCancelButton()
        configureSaveButton()
        configureTableView()
    }
    
    // MARK: - Setting a semi-transparent background
    private func configureDimmingView() {
        dimmingView.frame = view.bounds
        dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewInitialAlpha)
        view.addSubview(dimmingView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configuring the container (the ‘curtain’ itself)
    private func configureContainerView() {
        let sheetHeight: CGFloat = items.count > Constants.Numbers.rowsLimit ? view.bounds.height - Constants.Dimensions.sheetHeightOffset : Constants.Dimensions.sheetHeightSmall + Constants.Dimensions.rowHeight * CGFloat(items.count)
        
        containerView.frame = CGRect(
            x: Constants.Dimensions.containerX,
            y: view.bounds.height,
            width: view.bounds.width,
            height: sheetHeight
        )
        
        containerView.backgroundColor = Constants.Colors.containerBackgroundColor
        containerView.layer.cornerRadius = Constants.Dimensions.containerCornerRadius
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        finalY = view.bounds.height - sheetHeight
    }
    
    private func configurePeak() {
        peak.backgroundColor = Constants.Colors.peakColor
        peak.layer.cornerRadius = Constants.Dimensions.peakCornerRadius
        
        containerView.addSubview(peak)
        peak.frame = CGRect(
            x: (view.frame.width - Constants.Dimensions.peakWidth) / 2,
            y: Constants.Dimensions.peakTopMargin,
            width: Constants.Dimensions.peakWidth,
            height: Constants.Dimensions.peakHeight
        )
    }
    
    private func configureTitleLabel() {
        titleLabel.font = Constants.Fonts.titleLabelFont
        titleLabel.textColor = Constants.Colors.titleLabelTextColor
        
        containerView.addSubview(titleLabel)
        titleLabel.pinTop(to: containerView.topAnchor, Constants.Dimensions.titleLabelTopMargin)
        titleLabel.pinLeft(to: containerView.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle(Constants.Strings.cancel, for: .normal)
        cancelButton.setTitleColor(Constants.Colors.cancelButtonTextColor, for: .normal)
        cancelButton.backgroundColor = Constants.Colors.cancelButtonBackgroundColor
        cancelButton.titleLabel?.font = Constants.Fonts.buttonFont
        cancelButton.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        
        cancelButton.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        cancelButton.addTarget(nil, action: #selector(cancelButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        containerView.addSubview(cancelButton)
        cancelButton.pinBottom(to: containerView.bottomAnchor, Constants.Dimensions.buttonBottomMargin)
        cancelButton.setHeight(Constants.Dimensions.buttonHeight)
        cancelButton.pinLeft(to: containerView.leadingAnchor, Constants.Dimensions.buttonLeftRightMargin)
        cancelButton.pinRight(to: containerView.centerXAnchor, Constants.Dimensions.buttonSpacing)
    }
    
    private func configureSaveButton() {
        saveButton.setTitle(Constants.Strings.apply, for: .normal)
        saveButton.setTitleColor(Constants.Colors.saveButtonTextColor, for: .normal)
        saveButton.backgroundColor = Constants.Colors.saveButtonBackgroundColor
        saveButton.titleLabel?.font = Constants.Fonts.buttonFont
        saveButton.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        
        saveButton.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        saveButton.addTarget(nil, action: #selector(saveButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        containerView.addSubview(saveButton)
        saveButton.pinBottom(to: containerView.bottomAnchor, Constants.Dimensions.buttonBottomMargin)
        saveButton.setHeight(Constants.Dimensions.buttonHeight)
        saveButton.pinRight(to: containerView.trailingAnchor, Constants.Dimensions.buttonLeftRightMargin)
        saveButton.pinLeft(to: containerView.centerXAnchor, Constants.Dimensions.buttonSpacing)
    }
    
    private func configureTableView() {
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        containerView.addSubview(tableView)
        if items.count >= Constants.Numbers.rowsLimit  {
            cinfigureSearchBar()
            tableView.pinTop(to: searchBar.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        } else {
            tableView.pinTop(to: titleLabel.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        }
        tableView.pinLeft(to: containerView.leadingAnchor)
        tableView.pinRight(to: containerView.trailingAnchor)
        tableView.pinBottom(to: saveButton.topAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = items.count >= Constants.Numbers.rowsLimit
        
        containerView.backgroundColor = Constants.Colors.containerBackgroundColor
    }
    
    private func cinfigureSearchBar() {
        containerView.addSubview(searchBar)
        
        searchBar.delegate = self
        searchBar.pinTop(to: titleLabel.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        searchBar.pinLeft(to: view.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    // MARK: - Show curtain (animation)
    func animateShow() {
        UIView.animate(withDuration: Constants.Dimensions.animateDuration) {
            self.containerView.frame.origin.y = self.finalY
            self.dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewFinalAlpha)
        }
    }
    
    // MARK: - Hide the curtain (animation)
    func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: Constants.Dimensions.animateDuration, animations: {
            self.containerView.frame.origin.y = self.view.bounds.height
            self.dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewInitialAlpha)
        }, completion: {_ in
            completion?()
        })
    }
    
    private func closeSheet() {
        animateDismiss {
            self.dismiss(animated: false)
        }
        delegate?.didCancle()
    }
    
    @objc
    private func didTapDimmingView() {
        closeSheet()
    }
    
    // MARK: - Drag gesture processing
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            let newY = containerView.frame.origin.y + translation.y
            if newY >= finalY {
                containerView.frame.origin.y = newY
                gesture.setTranslation(.zero, in: view)
                
                let totalDistance = view.bounds.height - finalY
                let currentDistance = containerView.frame.origin.y - finalY
                let progress = currentDistance / totalDistance
                let newAlpha = Constants.Alphas.dimmingViewFinalAlpha * (1 - progress)
                dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(newAlpha)
            }
            
        case .ended, .cancelled:
            if velocity.y > Constants.Velocities.maxPanVelocity {
                closeSheet()
            } else {
                let distanceMoved = containerView.frame.origin.y - finalY
                let totalDistance = view.bounds.height - finalY
                
                if distanceMoved > totalDistance * Constants.Fractions.dismissThreshold {
                    closeSheet()
                } else {
                    UIView.animate(withDuration: Constants.Dimensions.animateDuration) {
                        self.containerView.frame.origin.y = self.finalY
                        self.dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewFinalAlpha)
                    }
                }
            }
        default:
            break
        }
    }
}

extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func calculateTableHeight() -> CGFloat {
        return CGFloat(min(currentItems.count, Constants.Numbers.rowsLimit)) * Constants.Dimensions.rowHeight
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: indexPath) as? OptionsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = currentItems[indexPath.row]
        cell.titleLabel.text = item.title
        
        if isMultipleChoice {
            let imageName = currentSelectedIndices.contains(indexPath.row) ? Constants.Images.filledSquare : Constants.Images.square
            cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        } else {
            let imageName = currentSelectedIndices.contains(indexPath.row) ? Constants.Images.filledCircle : Constants.Images.circle
            cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
        
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(at: indexPath)
        }
        
        let isLastCell = indexPath.row == currentItems.count - 1
        cell.hideSeparator(isLastCell)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleButtonTap(at: indexPath)
    }
    
    // MARK: - Press processing
    private func handleButtonTap(at indexPath: IndexPath) {
        if currentSelectedIndices.contains(indexPath.row) {
            currentSelectedIndices.remove(indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            if let originIndex = currentToAll[indexPath.row] {
                selectedIndices.remove(originIndex)
            }
            return
        }
        currentSelectedIndices.insert(indexPath.row)
        if let originIndex = currentToAll[indexPath.row] {
            selectedIndices.insert(originIndex)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        if !isMultipleChoice {
            for number in selectedIndices {
                if allToCurrent[number] != indexPath.row {
                    if let currentIndex = allToCurrent[number] {
                        currentSelectedIndices.remove(currentIndex)
                        tableView.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
                    }
                    selectedIndices.remove(number)
                    break
                }
            }
        }
    }
    
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        
    }
    
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            sender.transform = .identity
        }
    }
    
    @objc func cancelButtonTouchUp(_ sender: UIButton) {
        buttonTouchUp(sender)
        //        delegate?.didCancle()
        
        closeSheet()
    }
    
    @objc func saveButtonTouchUp(_ sender: UIButton) {
        buttonTouchUp(sender)
        initialSelectedIndices = selectedIndices
        delegate?.didSelectOption(Array(selectedIndices))
        animateDismiss {
            self.dismiss(animated: false)
        }
    }
}

extension OptionsViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        let request = Options.TextDidChange.Request(query: text)
        interactor?.textDidChange(request: request)
    }
}

extension OptionsViewController: OptionsDisplayLogic {
    func displayTextDidChange(viewModel: Options.TextDidChange.ViewModel) {
        currentToAll.removeAll()
        allToCurrent.removeAll()
        currentSelectedIndices.removeAll()
        for item in viewModel.options {
            currentToAll[item.currentIndex] = item.realIndex
            allToCurrent[item.realIndex] = item.currentIndex
        }
        for index in selectedIndices {
            if let currentIndex = allToCurrent[index] {
                currentSelectedIndices.insert(currentIndex)
            }
        }
        currentItems = viewModel.options
        tableView.reloadData()
    }
}

// MARK: - Constants
fileprivate enum Constants {
    // MARK: - Colors
    enum Colors {
        static let dimmingViewColor = UIColor.black
        static let peakColor = UIColor(hex: "#D9D9D9")
        static let cancelButtonBackgroundColor = UIColor(hex: "#E7E7E7")
        static let saveButtonBackgroundColor = UIColor(hex: "#E0E8FE")
        static let titleLabelTextColor = UIColor.black
        static let cancelButtonTextColor = UIColor.black
        static let saveButtonTextColor = UIColor.black
        static let containerBackgroundColor = UIColor.white
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let titleLabelFont = UIFont(name: "MontserratAlternates-Regular", size: 26)!
        static let buttonFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
    }
    
    // MARK: - Dimensions
    enum Dimensions {
        static let peakCornerRadius: CGFloat = 1.0
        static let containerCornerRadius: CGFloat = 25.0
        static let peakWidth: CGFloat = 45.0
        static let peakHeight: CGFloat = 3.0
        static let peakTopMargin: CGFloat = 6.0
        static let titleLabelTopMargin: CGFloat = 21.0
        static let titleLabelLeftMargin: CGFloat = 20.0
        static let buttonHeight: CGFloat = 48.0
        static let buttonBottomMargin: CGFloat = 37.0
        static let buttonLeftRightMargin: CGFloat = 20.0
        static let buttonSpacing: CGFloat = 2.5
        static let tableViewTopMargin: CGFloat = 5.0
        static let animateDuration: TimeInterval = 0.3
        static let containerX: CGFloat = 0.0
        static let containerCornerRadiusValue: CGFloat = 25.0
        static let sheetHeightOffset: CGFloat = 100.0
        static let sheetHeightSmall: CGFloat = 157.0
        static let rowHeight: CGFloat = 46.0
        static let buttonCornerRadius: CGFloat = 14.0
    }
    
    // MARK: - Alphas
    enum Alphas {
        static let dimmingViewInitialAlpha: CGFloat = 0.0
        static let dimmingViewFinalAlpha: CGFloat = 0.5
    }
    
    // MARK: - Numbers
    enum Numbers {
        static let rowsLimit: Int = 6
    }
    
    // MARK: - Velocities
    enum Velocities {
        static let maxPanVelocity: CGFloat = 600.0
    }
    
    // MARK: - Fractions
    enum Fractions {
        static let dismissThreshold: CGFloat = 0.5
    }
    
    // MARK: - Images
    enum Images {
        static let filledSquare = "inset.filled.square"
        static let square = "square"
        static let filledCircle = "inset.filled.circle"
        static let circle = "circle"
    }
    
    // MARK: - Strings
    enum Strings {
        static let cancel = "Отменить"
        static let apply = "Применить"
    }
}
