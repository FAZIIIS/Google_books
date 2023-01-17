//
//  ViewController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 01/01/23.
//

import UIKit
import SnapKit

class FavoritesScreenViewController: UIViewController {
    
//MARK: - PREOPERTIES
    
    var viewModel = FavoritesScreenViewModel()
    var localManager = CoreDataManager.shared
    
//MARK: - UI ELEMENTS
    
    let screenTitle: UILabel = {
        var view = UILabel()
        view.text = "Избранное"
        view.font = .boldSystemFont(ofSize: 30)
        view.textColor = .black
        
        return view
    }()
    
    var tableView: UITableView = {
        var view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DefaultTableViewCells.self, forCellReuseIdentifier: DefaultTableViewCells.ID)
        
        return view
    }()
    
    private let isEmptytableView: UILabelWithInsets = {
        let view = UILabelWithInsets()
        view.font = view.font.withSize(16)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .gray
        view.textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        view.text = "Здесь появятся Ваши избранные книги"
        return view
    }()
    
    
//MARK: - METHODS
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: screenTitle)
    }
    
    func setupUIElements() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        if viewModel.localManager.favoriteBook.isEmpty {
            tableView.backgroundView = isEmptytableView
            viewModel.localManager.getAllItems()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.localManager.delegate = self
        viewModel.localManager.getAllItems()
    }
    

//MARK: - LYFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        setupUIElements()
    }
}


//MARK: - TABLE DELEGATE & DATA SOURCE

extension FavoritesScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCells.ID, for: indexPath) as? DefaultTableViewCells else { return UITableViewCell()}
        
        defaultCell.configureCell(model: self.viewModel.localManager.favoriteBook[indexPath.row])
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.localManager.favoriteBook[indexPath.row]
        let vm = FavoriteBookDetailsViewModel(model: model)
        let vc = FavoriteBookDetailViewController(viewModel: vm)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - CoreDataDelegate IMPLEMETS

extension FavoritesScreenViewController: CoreDataDelegate {
    
    func updateData() {
        self.tableView.backgroundView = nil
        
        if viewModel.localManager.favoriteBook.isEmpty {
            tableView.backgroundView = isEmptytableView
        }

        tableView.reloadData()
    }
}
