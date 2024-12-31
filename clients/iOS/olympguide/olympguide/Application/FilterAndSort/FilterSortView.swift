//
//  FilterSortView.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

protocol FilterSortViewDelegate: AnyObject {
    /// Вызывается, когда пользователь нажал на кнопку сортировки
    func filterSortViewDidTapSortButton(_ view: FilterSortView)
    
    /// Вызывается, когда пользователь нажал на конкретный фильтр
    func filterSortView(_ view: FilterSortView, didTapFilterWithTitle title: String)
}

/// Кастомная вью для отображения сортировки и фильтров в одной горизонтальной строке
final class FilterSortView: UIView {
    
    // MARK: - UI
    weak var delegate: FilterSortViewDelegate?
    
    /// Горизонтальный скролл, в котором лежат иконка сортировки и фильтры
    private lazy var horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// Горизонтальный stackView, куда добавляем sortButton + фильтры
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5 // Расстояние между кнопками
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Инициализация
    
    /// Инициализатор, принимающий опции сортировки и фильтрации
    init(sortingOptions: [String], filteringOptions: [String]) {
        super.init(frame: .zero)
        setupUI()
        configure(sortingOptions: sortingOptions, filteringOptions: filteringOptions)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Настройка интерфейса
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Добавляем UIScrollView
        addSubview(horizontalScrollView)
        
        // Внутрь scrollView добавляем stackView
        horizontalScrollView.addSubview(horizontalStackView)
        
        // Констрейним scrollView к границам самой вью:
        NSLayoutConstraint.activate([
            horizontalScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: topAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // А stackView констрейним к внутренним краям scrollView
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor, constant: 8),
            horizontalStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor, constant: -8),
            horizontalStackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),
            // Фиксируем высоту, чтобы определить contentSize scrollView
            horizontalStackView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor)
        ])
    }
    
    /// Заполняем вью элементами
    private func configure(sortingOptions: [String], filteringOptions: [String]) {
        // Очищаем stackView
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем кнопку сортировки
        let sortButton = createSortButton()
        horizontalStackView.addArrangedSubview(sortButton)
        
        // Добавляем кнопки фильтров
        for filter in filteringOptions {
            let filterButton = createFilterButton(with: filter)
            horizontalStackView.addArrangedSubview(filterButton)
        }
    }
    
    // MARK: - Создание кнопок
    
    /// Создаёт кнопку сортировки
    private func createSortButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = .black
        
        // Установка размеров кнопки сортировки (28x28)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }
    
    /// Создаёт кнопку фильтрации
    private func createFilterButton(with title: String) -> UIButton {
        let button = FilterButton(title: title)
        
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }
    
    // MARK: - Обработчики нажатий
    
    @objc
    private func sortButtonTapped() {
        delegate?.filterSortViewDidTapSortButton(self)
    }
    
    @objc
    private func filterButtonTapped(_ sender: UIButton) {
        guard let filterButton = sender as? FilterButton else { return }
        let title = filterButton.filterTitle
        delegate?.filterSortView(self, didTapFilterWithTitle: title)
    }
}
