//
//  SortOptionsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

final class OptionsViewController: UIViewController {
    
    private let items: [String]
    
    // Полупрозрачная вью (фон)
    private let dimmingView = UIView()
    
    // Контейнер шторки
    private let containerView = UIView()
    
    // Pan-жест, чтобы тянуть шторку вниз
    private var panGesture: UIPanGestureRecognizer!
    
    // Позиция, куда шторка «приедет» (верх контейнера)
    private var finalY: CGFloat = 0
    
    private let peak: UIView = {
        $0.backgroundColor = UIColor(hex: "#D9D9D9")
        $0.layer.cornerRadius = 1
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.font = UIFont(name: "MontserratAlternates-Regular", size: 26)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let cancleButton: UIButton = {
        $0.setTitle("Отменить", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(hex: "#E7E7E7")
        $0.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        $0.layer.cornerRadius = 14
        return $0
    }(UIButton())
    
    private let saveButton: UIButton = {
        $0.setTitle("Применить", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(hex: "#E0E8FE")
        $0.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        $0.layer.cornerRadius = 14
        return $0
    }(UIButton())
    
    var isMultipleChoice: Bool = true
    
    // Хранение выбранных индексов
    var selectedIndices: Set<Int> = []
    var selectedIndex: Int? = nil // Для одиночного выбора
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.separatorStyle = .none // Отключаем стандартные сепараторы
        return table
    }()
    
    init(items: [String], titleLabel: String) {
        self.items = items
        self.titleLabel.text = titleLabel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDimmingView()
        setupContainerView()
        setupGesture()
        setupContent()
    }
    
    // MARK: - Настройка полупрозрачного фона
    private func setupDimmingView() {
        // dimmingView занимает весь экран
        dimmingView.frame = self.view.bounds
        // Изначально полностью прозрачный
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(dimmingView)
        
        // Тап по фону — закрыть шторку
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Настройка контейнера (самой "шторки")
    private func setupContainerView() {
        // Определяем, какой должна быть высота шторки
        // Для примера берём статическую высоту 400, но можно вычислять по контенту
        let sheetHeight: CGFloat = items.count > 5 ? view.bounds.height - 100 : 157 + 46 * CGFloat(items.count)
        
        // Начальная позиция: за нижней гранью экрана
        containerView.frame = CGRect(
            x: 0,
            y: view.bounds.height,
            width: view.bounds.width,
            height: sheetHeight
        )
        
        // Скруглим верхние углы
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 25
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        
        // Добавляем на иерархию
        view.addSubview(containerView)
        
        // Рассчитаем целевую позицию (на сколько поднимаем)
        finalY = view.bounds.height - sheetHeight
        
        containerView.addSubview(peak)
        peak.frame = CGRect(x: (view.frame.width - 45) / 2, y: 6, width: 45, height: 3)
        
        containerView.addSubview(titleLabel)
        titleLabel.pinTop(to: containerView.topAnchor, 21)
        titleLabel.pinLeft(to: containerView.leadingAnchor, 20)
        
    }
    
    // MARK: - Настройка Pan-жеста (чтобы тянуть шторку вниз)
    private func setupGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Пример контента (просто метка)
    private func setupContent() {
        containerView.addSubview(cancleButton)
        cancleButton.pinBottom(to: containerView.bottomAnchor, 37)
        cancleButton.setHeight(48)
        cancleButton.pinLeft(to: containerView.leadingAnchor, 20)
        cancleButton.pinRight(to: containerView.centerXAnchor, 2.5)
        
        containerView.addSubview(saveButton)
        saveButton.pinBottom(to: containerView.bottomAnchor, 37)
        saveButton.setHeight(48)
        saveButton.pinRight(to: containerView.trailingAnchor, 20)
        saveButton.pinLeft(to: containerView.centerXAnchor, 2.5)
        
        containerView.addSubview(tableView)
        tableView.pinTop(to: titleLabel.bottomAnchor, 5)
        tableView.pinLeft(to: containerView.leadingAnchor)
        tableView.pinRight(to: containerView.trailingAnchor)
        tableView.pinBottom(to: saveButton.topAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        // Отключаем прокрутку, если элементов меньше 6
        tableView.isScrollEnabled = items.count >= 6
        
        // Покрасим вью, чтобы визуально увидеть границы
        containerView.backgroundColor = .white
        

    }
    
    // MARK: - Показать шторку (анимация)
    func animateShow() {
        UIView.animate(withDuration: 0.3) {
            // Поднимаем контейнер
            self.containerView.frame.origin.y = self.finalY
            // Затемняем фон до какой-то альфы (например, 0.5)
            self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    // MARK: - Спрятать шторку (анимация)
    func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            // Уводим контейнер вниз за экран
            self.containerView.frame.origin.y = self.view.bounds.height
            // Возвращаем фон к прозрачности
            self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: { _ in
            completion?()
        })
    }
    
    // MARK: - Обработка нажатия на фон (закрытие)
    @objc private func didTapDimmingView() {
        closeSheet()
    }
    
    private func closeSheet() {
        // Сначала уводим шторку анимацией
        animateDismiss {
            // Затем закрываем модальный экран
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - Обработка жеста перетаскивания
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            // Текущая позиция
            let newY = containerView.frame.origin.y + translation.y
            
            // Не даём уехать выше, чем finalY
            if newY >= finalY {
                containerView.frame.origin.y = newY
                gesture.setTranslation(.zero, in: view)
                
                // Меняем альфу dimmingView в зависимости от того, насколько сдвинули
                let totalDistance = view.bounds.height - finalY
                let currentDistance = containerView.frame.origin.y - finalY
                let progress = currentDistance / totalDistance // от 0 до 1
                // Альфа от 0.5 до 0.0
                let newAlpha = 0.5 * (1 - progress)
                dimmingView.backgroundColor = UIColor.black.withAlphaComponent(newAlpha)
            }
            
        case .ended, .cancelled:
            // Если «дёргаем» вниз с большой скоростью — закрыть
            if velocity.y > 600
            {
                closeSheet()
            } else {
                // Смотрим, прошли ли 50% пути вниз
                let distanceMoved = containerView.frame.origin.y - finalY
                let totalDistance = view.bounds.height - finalY
                
                if distanceMoved > totalDistance * 0.5 {
                    // Закрываем
                    closeSheet()
                } else {
                    // Возвращаем обратно
                    UIView.animate(withDuration: 0.3) {
                        self.containerView.frame.origin.y = self.finalY
                        self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    }
                }
            }
        default:
            break
        }
    }
}


extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    // Функция для расчёта высоты таблицы
    private func calculateTableHeight() -> CGFloat {
        let rowHeight: CGFloat = 45 // Стандартная высота строки
        let numberOfRows = min(items.count, 6)
        return CGFloat(numberOfRows) * rowHeight
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
           return UITableViewCell()
       }
       
       let item = items[indexPath.row]
       cell.titleLabel.text = item
       
       // Настраиваем кнопку в зависимости от выбора
       if isMultipleChoice {
           let imageName = selectedIndices.contains(indexPath.row) ? "inset.filled.square" : "square"
           cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
       } else {
           let imageName = selectedIndex == indexPath.row ? "inset.filled.circle" : "circle"
           cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
       }
       
       // Обработка нажатия кнопки
       cell.buttonAction = { [weak self] in
           self?.handleButtonTap(at: indexPath)
       }
       
       // Скрываем сепаратор у последней ячейки
       let isLastCell = indexPath.row == items.count - 1
       cell.hideSeparator(isLastCell)
       
       return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleButtonTap(at: indexPath)
    }
    
    // MARK: - Обработка нажатий
    
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
}
