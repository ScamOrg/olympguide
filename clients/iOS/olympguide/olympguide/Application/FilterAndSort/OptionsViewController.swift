//
//  SortOptionsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

final class OptionsViewController: UIViewController {
    
    // MARK: - Properties
    private let items: [String]
    
    private let dimmingView = UIView()
    private let containerView = UIView()
    private var panGesture: UIPanGestureRecognizer!
    private var finalY: CGFloat = 0
    
    private let peak: UIView = {
        $0.backgroundColor = Constants.Colors.peakColor
        $0.layer.cornerRadius = Constants.Dimensions.peakCornerRadius
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.font = Constants.Fonts.titleLabelFont
        $0.textColor = Constants.Colors.titleLabelTextColor
        return $0
    }(UILabel())
    
    private let cancelButton: UIButton = {
        $0.setTitle(Constants.Strings.cancel, for: .normal)
        $0.setTitleColor(Constants.Colors.cancelButtonTextColor, for: .normal)
        $0.backgroundColor = Constants.Colors.cancelButtonBackgroundColor
        $0.titleLabel?.font = Constants.Fonts.buttonFont
        $0.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        
        $0.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        $0.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        return $0
    }(UIButton())
    
    private let saveButton: UIButton = {
        $0.setTitle(Constants.Strings.apply, for: .normal)
        $0.setTitleColor(Constants.Colors.saveButtonTextColor, for: .normal)
        $0.backgroundColor = Constants.Colors.saveButtonBackgroundColor
        $0.titleLabel?.font = Constants.Fonts.buttonFont
        $0.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        
        $0.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        $0.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        return $0
    }(UIButton())
    
    private var isMultipleChoice: Bool
    var selectedIndices: Set<Int> = []
    var selectedIndex: Int? = nil
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    init(items: [String], title: String, isMultipleChoice: Bool) {
        self.items = items
        self.titleLabel.text = title
        self.isMultipleChoice = isMultipleChoice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen
        configureDimmingView()
        configureContainerView()
        configureGesture()
        configureContent()
    }
    
    // MARK: - Funcs
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
        
        containerView.addSubview(peak)
        peak.frame = CGRect(
            x: (view.frame.width - Constants.Dimensions.peakWidth) / 2,
            y: Constants.Dimensions.peakTopMargin,
            width: Constants.Dimensions.peakWidth,
            height: Constants.Dimensions.peakHeight
        )
        
        containerView.addSubview(titleLabel)
        titleLabel.pinTop(to: containerView.topAnchor, Constants.Dimensions.titleLabelTopMargin)
        titleLabel.pinLeft(to: containerView.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    // MARK: - Pan gesture setting (to pull the curtain down)
    private func configureGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Content configuration
    private func configureContent() {
        containerView.addSubview(cancelButton)
        cancelButton.pinBottom(to: containerView.bottomAnchor, Constants.Dimensions.buttonBottomMargin)
        cancelButton.setHeight(Constants.Dimensions.buttonHeight)
        cancelButton.pinLeft(to: containerView.leadingAnchor, Constants.Dimensions.buttonLeftRightMargin)
        cancelButton.pinRight(to: containerView.centerXAnchor, Constants.Dimensions.buttonSpacing)
        
        containerView.addSubview(saveButton)
        saveButton.pinBottom(to: containerView.bottomAnchor, Constants.Dimensions.buttonBottomMargin)
        saveButton.setHeight(Constants.Dimensions.buttonHeight)
        saveButton.pinRight(to: containerView.trailingAnchor, Constants.Dimensions.buttonLeftRightMargin)
        saveButton.pinLeft(to: containerView.centerXAnchor, Constants.Dimensions.buttonSpacing)
        
        containerView.addSubview(tableView)
        tableView.pinTop(to: titleLabel.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        tableView.pinLeft(to: containerView.leadingAnchor)
        tableView.pinRight(to: containerView.trailingAnchor)
        tableView.pinBottom(to: saveButton.topAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = items.count >= Constants.Numbers.rowsLimit
        
        containerView.backgroundColor = Constants.Colors.containerBackgroundColor
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
        return CGFloat(min(items.count, Constants.Numbers.rowsLimit)) * Constants.Dimensions.rowHeight
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: indexPath) as? OptionsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.titleLabel.text = item
        
        if isMultipleChoice {
            let imageName = selectedIndices.contains(indexPath.row) ? Constants.Images.filledSquare : Constants.Images.square
            cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        } else {
            let imageName = selectedIndex == indexPath.row ? Constants.Images.filledCircle : Constants.Images.circle
            cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
        
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(at: indexPath)
        }
        
        let isLastCell = indexPath.row == items.count - 1
        cell.hideSeparator(isLastCell)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleButtonTap(at: indexPath)
    }
    
    // MARK: - Press processing
    private func handleButtonTap(at indexPath: IndexPath) {
        if isMultipleChoice {
            if selectedIndices.contains(indexPath.row) {
                selectedIndices.remove(indexPath.row)
            } else {
                selectedIndices.insert(indexPath.row)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            var indexPathsToReload: [IndexPath] = []
            if let previous = selectedIndex, previous != indexPath.row {
                indexPathsToReload.append(IndexPath(row: previous, section: 0))
            }
            if selectedIndex == indexPath.row {
                selectedIndex = nil
            } else {
                selectedIndex = indexPath.row
                indexPathsToReload.append(indexPath)
            }
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
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
    
    @objc
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            sender.transform = .identity
        }
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
