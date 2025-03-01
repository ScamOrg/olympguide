//
//  FavoriteProgramsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit
import Combine

final class FavoriteProgramsViewController: UIViewController {
    var interactor: (FavoriteProgramsBusinessLogic & FavoriteProgramsDataStore)?
    var router: FavoriteProgramsRoutingLogic?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var programs: [ProgramViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        
        interactor?.loadPrograms(with: .init())
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        programs = programs.map { program in
//            var modifiedProgram = program
//            modifiedProgram.like = isFavorite(
//                programID: program.programID,
//                serverValue: program.like
//            )
//            return modifiedProgram
//        }.filter { $0.like }
//        
//        tableView.reloadData()
//        tableView.backgroundView = getEmptyLabel()
//    }
    
    private func configureUI() {
        configureNavigationBar()
        configureRefreshControl()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        let backItem = UIBarButtonItem(title: "Избранные", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        navigationItem.title = "Избранные программы"
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
    }
    
    func getEmptyLabel() -> UILabel? {
        guard programs.isEmpty else { return nil }
        
        let emptyLabel = UILabel(frame: self.tableView.bounds)
        emptyLabel.text = "Избранных программ пока нет"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .black
        emptyLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 18)
        self.tableView.backgroundView = emptyLabel
        
        return emptyLabel
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.interactor?.loadPrograms(with: FavoritePrograms.Load.Request())
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteProgramsViewController : UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return programs.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier,
            for: indexPath
        ) as? ProgramTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        
        let program = programs[indexPath.row]
        cell.configure(with: program)
        
        cell.favoriteButtonTapped = { sender, isFavorite in
            if !isFavorite {
                FavoritesManager.shared.removeProgramFromFavorites(programID: sender.tag)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteProgramsViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToProgram(with: indexPath.row)
    }
}

// MARK: - FavoriteProgramsDisplayLogic
extension FavoriteProgramsViewController : FavoriteProgramsDisplayLogic {
    func displayLoadProgramsResult(with viewModel: FavoritePrograms.Load.ViewModel) {
        
        programs = viewModel.programs
                
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.tableView.backgroundView = getEmptyLabel()
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Combine
extension FavoriteProgramsViewController {
    func setupBindings() {
        FavoritesManager.shared.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let program):
                    if !self.programs.contains(where: {$0.programID == program.programID}) {
                        let viewModel = ProgramViewModel(
                            programID: program.programID,
                            name: program.name,
                            code: program.field,
                            budgetPlaces: program.budgetPlaces,
                            paidPlaces: program.paidPlaces,
                            cost: program.cost,
                            like: program.like,
                            requiredSubjects: program.requiredSubjects,
                            optionalSubjects: program.optionalSubjects
                        )
                        
                        let insertIndex = self.programs.firstIndex { $0.programID > program.programID } ?? self.programs.count
                        
                        self.interactor?.likeProgram(program, at: insertIndex)
                        self.programs.insert(viewModel, at: insertIndex)
                        
                        let newIndex = IndexPath(row: insertIndex, section: 0)
                        self.tableView.insertRows(at: [newIndex], with: .automatic)
                        self.tableView.backgroundView = nil
                    }
                case .removed(let programID):
                    if let index = self.programs.firstIndex(where: { $0.programID == programID }) {
                        if !self.programs[index].like { break }
                        self.programs.remove(at: index)
                        self.interactor?.dislikeProgram(at: index)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        self.tableView.backgroundView = self.getEmptyLabel()
                    }
                case .error(let programID):
                    interactor?.handleBatchError(programID: programID)
                case .access(let programID, let isFavorite):
                    interactor?.handleBatchSuccess(programID: programID, isFavorite: isFavorite)
                }
            }.store(in: &cancellables)
    }
    
    func isFavorite(programID: Int, serverValue: Bool) -> Bool {
        FavoritesManager.shared.isProgramFavorited(
            programID: programID,
            serverValue: serverValue
        )
    }
}
