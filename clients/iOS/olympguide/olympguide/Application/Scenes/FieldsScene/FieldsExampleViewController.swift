//
//  DirectionsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

class FieldsExampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Category {
        let title: String
        var subcategories: [String]
        var isExpanded: Bool // Флаг для раскрытия секции
    }

    var categories: [Category] = [
        Category(title: "Математика и механика", subcategories: ["Математика", "Прикладная математика и информатика", "Механика и математическое моделирование"], isExpanded: false),
        Category(title: "Компьютерные и информационные науки", subcategories: ["Программирование", "Алгоритмы"], isExpanded: false),
    ]
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Отключаем верхний отступ заголовков секций на iOS 15 и выше
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    // Настройка UITableView программно
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // Количество секций — равно количеству главных категорий
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    // Количество строк в секции зависит от того, раскрыта она или нет
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].isExpanded ? categories[section].subcategories.count : 0
    }

    // Заголовок для каждой секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].title
    }

    // Настройка ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.section].subcategories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Настраиваемая высота для заголовков
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01 // Убирает лишнее пространство под секцией
    }

    // Обработка нажатия на строку (подкатегорию)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрана подкатегория: \(categories[indexPath.section].subcategories[indexPath.row])")
    }

    // Создание заголовка секции с кнопкой для раскрытия/сворачивания
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerButton = UIButton(type: .system)
        headerButton.setTitle(categories[section].title, for: .normal)
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        headerButton.backgroundColor = .lightGray // Для выделения заголовка
        headerButton.setTitleColor(.black, for: .normal)
        return headerButton
    }

    @objc
    func toggleSection(sender: UIButton) {
        let section = sender.tag
        categories[section].isExpanded.toggle()
        tableView.reloadSections([section], with: .automatic)
    }
}
