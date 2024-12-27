//
//  ChoiceCell.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        // Устанавливаем начальное изображение
        button.setImage(UIImage(systemName: "square"), for: .normal)
        return button
    }()
    
    // Кастомный сепаратор
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#E7E7E7")
        return view
    }()
    
    // Callback для обработки нажатия кнопки
    var buttonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Отключаем стандартное выделение
        selectionStyle = .none
        
        // Добавляем подвиды
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(separatorLine)
        
        // Настраиваем ограничения
        titleLabel.pinLeft(to: contentView.leadingAnchor, 20)
        titleLabel.pinCenterY(to: contentView)
        
        actionButton.pinRight(to: contentView.trailingAnchor, 20)
        actionButton.pinCenterY(to: contentView)
        actionButton.setHeight(24)
        actionButton.setWidth(24)
        
        titleLabel.pinRight(to: actionButton.leadingAnchor, 8, .lsOE)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, 20)
        separatorLine.pinRight(to: contentView.trailingAnchor, 20)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
        
        // Добавляем действие на кнопку
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    // Метод для скрытия сепаратора
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



import UIKit

class SpecialViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Исходный массив строк
    var items: [String] = ["Элемент 1", "Элемент 2", "Элемент 3", "Элемент 4", "Элемент 5"]
    
    // Параметр выбора
    var isMultipleChoice: Bool = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Добавляем таблицу
        view.addSubview(tableView)
        
        // Настраиваем ограничения
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: calculateTableHeight())
        ])
        
        // Настраиваем делегаты
        tableView.dataSource = self
        tableView.delegate = self
        
        // Отключаем прокрутку, если элементов меньше 6
        tableView.isScrollEnabled = items.count >= 6
    }
    
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
