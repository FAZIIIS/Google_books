//
//  ViewController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 01/01/23.
//

import UIKit
import SnapKit

class MainScreenViewController: UIViewController {
    
    //MARK: - PREOPERTIES
    
    var viewModel = MainScreenViewModel()
    
    //MARK: - UI ELEMENTS
    
    let screenTitle: UILabel = {
        var view = UILabel()
        view.text = "Главная"
        view.font = .boldSystemFont(ofSize: 30)
        view.textColor = .black
        
        return view
    }()
    
    var tableView: UITableView = {
        var view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DefaultTableViewCells.self, forCellReuseIdentifier: DefaultTableViewCells.ID)
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .singleLine
        
        return view
    }()
    
    private let isEmptytableView: UILabelWithInsets = {
        let view = UILabelWithInsets()
        view.font = view.font.withSize(16)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .gray
        view.textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return view
    }()
    
    private lazy var tableViewPullToRefresh: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = #colorLiteral(red: 0.2392909527, green: 0.2576019466, blue: 0.8100883365, alpha: 1)
        
        return view
    }()
    
    private let rightSearchBarButton: UIButton = {
        var view = UIButton(type: .system)
        view.tintColor = .blue
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        return view
    }()
    
    private var searchBar: UISearchBar = {
        var view = UISearchBar()
        
        return view
    }()
    
    private var cancelNavigationBarButton: UIButton = {
        var view = UIButton(type: .system)
        view.setTitle("Отмена", for: .normal)
        view.tintColor = #colorLiteral(red: 0.2392909527, green: 0.2576019466, blue: 0.8100883365, alpha: 1)
        
        return view
    }()
    
    
    //MARK: - METHODS
    
    private func setupUIElements() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        if viewModel.books.isEmpty {
            tableView.backgroundView = isEmptytableView
            viewModel.getBooks(search: "swiftui")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        searchBar.delegate = self
        
        tableView.keyboardDismissMode = .onDrag
        
        tableViewPullToRefresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        rightSearchBarButton.addTarget(self, action: #selector(searchBarButtonDidTapped), for: .touchUpInside)
        cancelNavigationBarButton.addTarget(self, action: #selector(cancelNavigationBarButtonDidTapped), for: .touchUpInside)
    }
    
    private func createLoadingIndicator() -> UIView {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        var spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        return view
    }
    
    private func showSearchBarButton(shouldShow: Bool) {
        
        if shouldShow {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: screenTitle)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSearchBarButton)
            
            UIView.animate(withDuration: 0.3) {
                self.searchBar.alpha = 0
                self.rightSearchBarButton.alpha = 1
                self.screenTitle.alpha = 1
            } completion: { finished in
                self.navigationItem.titleView = nil
                self.searchBar.text = nil
            }
            
        } else {
            searchBar.alpha = 0
            navigationItem.titleView = searchBar
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
            UIView.animate(withDuration: 0.3) {
                self.searchBar.alpha = 1
                self.rightSearchBarButton.alpha = 0
                self.screenTitle.alpha = 0
            } completion: { finished in
                self.searchBar.becomeFirstResponder()
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelNavigationBarButton)
        }
    }
    
    
//MARK: - @objc METHODS
    
    @objc func pullToRefresh() {
        
        self.tableViewPullToRefresh.endRefreshing()
        viewModel.getBooks(search: viewModel.filterText)
    }
    
    @objc func searchBarButtonDidTapped() {
        
        showSearchBarButton(shouldShow: false)
    }
    
    @objc func cancelNavigationBarButtonDidTapped() {
        
        showSearchBarButton(shouldShow: true)
    }
    
    
    //MARK: - LYFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showSearchBarButton(shouldShow: true)
        setupUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.tabBarController?.setTabBarHidden(false)
    }
}


//MARK: - TABLE DELEGATE & DATA SOURCE

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCells.ID, for: indexPath) as? DefaultTableViewCells else { return UITableViewCell()}
        let model = self.viewModel.books[indexPath.row]
        defaultCell.isFavorite = viewModel.isFavorite(model: model)
        defaultCell.configureCell(model: model, tag: indexPath.row)
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = viewModel.books[indexPath.row]
        let vm = BookDetailsViewModel(model: model)
        vm.isFavorite = viewModel.isFavorite(model: model)
        let vc = BookDetailsViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.getDataWithPagination(indexPath: indexPath.row, text: viewModel.filterText)
    }
    
}


//MARK: - SEARCH DELEGATE & DATA SOURCE

extension MainScreenViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        viewModel.books.removeAll()
        viewModel.isPagination = false
        NetworkManager.shared.startIndex = 0
        viewModel.filterText = (searchBar.searchTextField.text ?? "").replacingOccurrences(of: " ", with: "+")
        tableView.backgroundView = isEmptytableView
        tableView.reloadData()
        viewModel.getBooks(search: viewModel.filterText)
        tableView.tableFooterView = nil
        print("⌨️ \(searchBar.searchTextField.text ?? "")")
    }
}


//MARK: - RequestResult DELEGATE

extension MainScreenViewController: RequestResult {
    
    func inSucces(dataFromServer: [SearchedBokInfo]) {

        if dataFromServer.isEmpty {
            tableView.backgroundView = nil
            isEmptytableView.text = "По вашему зарпосу ничего не найдено"
            tableView.backgroundView = isEmptytableView
            tableView.reloadData()
        } else {
            tableView.backgroundView = nil
            tableView.tableFooterView = nil
            tableView.reloadData()
        }
    }
    
    func startLoadingAnimating() {
        self.tableView.tableFooterView = createLoadingIndicator()
    }
    
    func showError() {
        let alert = UIAlertController(title: "Нестабильное интернет подключение!!!", message: "Проверьте соеденение и повторите заново", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


//MARK: - CORE DATA DELEGATE

extension MainScreenViewController: CoreDataDelegate {
    
    func updateData() {
        self.tableView.reloadData()
    }
}
