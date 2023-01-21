//
//  BookDetailsViewController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 06/01/23.
//

import Foundation
import UIKit
import SnapKit

class BookDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - PROPERTIES
    
    var viewModel: BookDetailsViewModel?
    var isLoadingData = false
    
    
    //MARK: - UI ELEMENTS
    
    private var downloadBookButton: UIButton = {
        var view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        view.setTitle("СКАЧАТЬ", for: .normal)
        view.tintColor = .white
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    private var bookImage: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private var scrennTitle: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemBlue
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 18)
        view.text = "Детальная информация"
        
        return view
    }()
    
    private var bookNameTitle: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 24)
        view.numberOfLines = 0
        
        return view
    }()
    
    private var bookAuthor: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0.6782422662, green: 0.6828836799, blue: 0.7166014314, alpha: 1)
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 14)
        view.numberOfLines = 0
        
        return view
    }()
    
    private var bookDescription: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = 0
        
        return view
    }()
    
    private var scrollScreen: UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceHorizontal = false
        
        return view
    }()
    
    private var addToFavorite: UIButton = {
        var view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .red
        
        return view
    }()
    
    private var verticalStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    
    //MARK: - METHDOS
    
    func setupUIElements(model: SearchedBokInfo) {
        
        guard let bookNameFromModel = model.volumeInfo?.title,
              let bookAuthorFromModel = model.volumeInfo?.authors,
              let bookDescriptionFromModel = model.volumeInfo?.description,
              let link = model.volumeInfo?.imageLinks?.thumbnail else { return }
        
        view.addSubview(scrollScreen)
        scrollScreen.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(bookImage)
        verticalStack.addArrangedSubview(addToFavorite)
        verticalStack.addArrangedSubview(bookNameTitle)
        verticalStack.addArrangedSubview(bookAuthor)
        verticalStack.addArrangedSubview(bookDescription)
        verticalStack.addArrangedSubview(downloadBookButton)
        
        verticalStack.setCustomSpacing(30, after: bookImage)
        verticalStack.setCustomSpacing(30, after: addToFavorite)
        verticalStack.setCustomSpacing(20, after: bookNameTitle)
        verticalStack.setCustomSpacing(20, after: bookAuthor)
        verticalStack.setCustomSpacing(43, after: bookDescription)
        
        scrollScreen.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(36)
        }
        
        bookDescription.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
        
        bookNameTitle.snp.makeConstraints { make in
            make.width.equalTo(bookDescription)
        }
        
        bookImage.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(330)
        }
        
        downloadBookButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        addToFavorite.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerX.equalTo(bookImage.snp_rightMargin)
            make.centerY.equalTo(bookImage.snp_bottomMargin)
        }
        
        viewModel?.request.downloadImage(URLAddress: link, completion: { imageFromServer in
            self.bookImage.image = imageFromServer
        })
        
        model.volumeInfo?.authors?.forEach { author in
            self.viewModel?.authors.append("\(author) \n")
        }
        
        bookNameTitle.text = bookNameFromModel
        bookAuthor.text = self.viewModel?.authors
        bookDescription.text = bookDescriptionFromModel
        viewModel?.delegate = self
        
        if viewModel?.isFavorite ?? false {
            addToFavorite.setBackgroundImage((UIImage(systemName: "heart.fill")), for: .normal)
        } else {
            addToFavorite.setBackgroundImage((UIImage(systemName: "heart")), for: .normal)
            addToFavorite.tintColor = .red
        }
        
        downloadBookButton.addTarget(self, action: #selector(downloadBookButtonDidTapped), for: .touchUpInside)
        
        addToFavorite.addTarget(self, action: #selector(addToFavoriteButtonDidTapped), for: .touchUpInside)
    }
    
    func setupNavigation() {
        navigationItem.titleView = scrennTitle
    }
    
    
//MARK: - @objc METHODS
    
    @objc func downloadBookButtonDidTapped() {
        if !isLoadingData {
            isLoadingData = true
            viewModel?.savePDF()
        }
    }
    
    @objc func addToFavoriteButtonDidTapped() {
        viewModel?.addBookToFavorite()
        if viewModel?.isFavorite ?? false {
            addToFavorite.setBackgroundImage((UIImage(systemName: "heart.fill")), for: .normal)
        } else {
            addToFavorite.setBackgroundImage((UIImage(systemName: "heart")), for: .normal)
            addToFavorite.tintColor = .red
        }
    }
    
    
    //MARK: - LYFE CYLCE
    
    init(viewModel: BookDetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        guard let model = self.viewModel?.model else { return }
        setupUIElements(model: model)
        setupNavigation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.setTabBarHidden(true)
    }
}


//MARK: - BookDetailsViewModelDelegate

extension BookDetailsViewController: BookDetailsViewModelProtocol {
    
    func openInWKWebView(urlForOpen: String) {
        let vc = PDFController(requetURL: urlForOpen)
        self.isLoadingData = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorWhileRequest() {
        let alert = UIAlertController(title: "Нестабильное интернет подключение!!!", message: "Возникла ошибка при скачивании /nПроверьте соеденение и повторите заново", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
