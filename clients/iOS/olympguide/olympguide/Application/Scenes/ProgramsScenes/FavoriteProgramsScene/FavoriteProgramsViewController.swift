//
//  FavoriteProgramsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteProgramsViewController: UIViewController {
    var interactor: FavoriteProgramsBusinessLogic?
    var router: FavoriteProgramsRoutingLogic?
    
    private let tableView: UITableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var programs: [ProgramViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        interactor?.loadPrograms(with: .init())
    }
    
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
    }
}

extension FavoriteProgramsViewController : FavoriteProgramsDisplayLogic {
    func displayLoadProgramsResult(with viewModel: FavoritePrograms.Load.ViewModel) {
        programs = viewModel.programs
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.programs.isEmpty {
                let emptyLabel = UILabel(frame: self.tableView.bounds)
                emptyLabel.text = "Избранных программ пока нет"
                emptyLabel.textAlignment = .center
                emptyLabel.textColor = .black
                emptyLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 18)
                self.tableView.backgroundView = emptyLabel
            } else {
                self.tableView.backgroundView = nil
            }
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}
