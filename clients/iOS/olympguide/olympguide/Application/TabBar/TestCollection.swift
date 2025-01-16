import UIKit

class CollapsibleCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldsDisplayLogic {
    func displayFields(viewModel: Fields.Load.ViewModel) {
        fields = viewModel.groupsOfFields
    }
    
    func displayError(message: String) {
        
    }
    
    
    var tableView: UITableView!
    var sections: [String] = ["Секция 1", "Секция 2", "Секция 3", "Секция 4", "Секция 5", "Секция 6","Секция 7", "Секция 8", "Секция 9","Секция 10", "Секция 11", "Секция 12","Секция 13", "Секция 14", "Секция 15","Секция 16", "Секция 17", "Секция 18","Секция 19", "Секция 20", "Секция 21","Секция 22", "Секция 23", "Секция 24", "Секция 1", "Секция 2", "Секция 3", "Секция 4", "Секция 5", "Секция 6","Секция 7", "Секция 8", "Секция 9","Секция 10", "Секция 11", "Секция 12","Секция 13", "Секция 14", "Секция 15","Секция 16", "Секция 17", "Секция 18","Секция 19", "Секция 20", "Секция 21","Секция 22", "Секция 23", "Секция 24"]
    var itemsInSections: [[String]] = [["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"], ["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"],["1A", "1B", "1C"], ["2A", "2B"], ["3A", "3B", "3C", "3D", "3E"]]
    var expandedSections: Set<Int> = []
    var interactor: (FieldsDataStore & FieldsBusinessLogic)?
    private var fields: [Fields.Load.ViewModel.GroupOfFieldsViewModel] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white

            let viewController = self
            let interactor = FieldsInteractor()
            let presenter = FieldsPresenter()
            let router = FieldsRouter()
            
            viewController.interactor = interactor
            interactor.presenter = presenter
            presenter.viewController = viewController
            router.viewController = viewController

            
            interactor.loadFields(
                Fields.Load.Request(searchQuery: nil, degree: nil)
            )
            // Инициализация таблицы
            tableView = UITableView(frame: view.bounds, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(
                ExFieldTableViewCell.self,
                forCellReuseIdentifier: "FieldTableViewCell"
            )
            view.addSubview(tableView)
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            print(fields.count)
            return sections.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return expandedSections.contains(section) ? itemsInSections[section].count : 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ExFieldTableViewCell.identifier,
                for: indexPath
            ) as! ExFieldTableViewCell
            
            let fieldViewModel = fields[indexPath.section].fields[indexPath.row]
            cell.configure(with: fieldViewModel)
            return cell
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sections[section]
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = UITableViewHeaderFooterView()
            header.textLabel?.text = sections[section]
            header.contentView.backgroundColor = .lightGray
            header.tag = section

            // Добавление жеста для нажатия на заголовок секции
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSection(_:)))
            header.addGestureRecognizer(tapGesture)

            return header
        }

        @objc func toggleSection(_ sender: UITapGestureRecognizer) {
            guard let section = sender.view?.tag else { return }

            // Сохранение текущей позиции скролла
            let currentOffset = tableView.contentOffset

            let isExpanded = expandedSections.contains(section)
            if isExpanded {
                expandedSections.remove(section)
            } else {
                expandedSections.insert(section)
            }

            // Обновление секции без анимации
            UIView.performWithoutAnimation {
                tableView.reloadSections(IndexSet(integer: section), with: .none)
                tableView.layer.removeAllAnimations()
            }

            // Восстановление позиции скролла
            tableView.setContentOffset(currentOffset, animated: false)
        }
    }
