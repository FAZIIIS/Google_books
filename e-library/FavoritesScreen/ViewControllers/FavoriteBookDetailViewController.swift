//
//  FavoriteBookDetailViewController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 15/01/23.
//

import Foundation
import UIKit
import SnapKit

class FavoriteBookDetailViewController: UIViewController {
    
//MARK: - PROPERTIES
    
    var viewModel: FavoriteBookDetailsViewModel?
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
    
    
//MARK: - METHODS
    
    func setupUIElements(model: FavoriteBook) {
        guard let bookNameFromModel = model.name,
              let bookAuthorFromModel = model.author,
              let bookDescriptionFromModel = model.bookDescription,
              let isFavorite = viewModel?.isFavorite,
              let link = model.image else { return }
        
        viewModel?.isFavorite = isFavorite
        
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

        NetworkManager.shared.downloadImage(URLAddress: link, completion: { imageFromServer in
            self.bookImage.image = imageFromServer
        })
        
        bookNameTitle.text = bookNameFromModel
        bookAuthor.text = bookAuthorFromModel
        bookDescription.text = bookDescriptionFromModel

        downloadBookButton.addTarget(self, action: #selector(downloadBookButtonDidTapped), for: .touchUpInside)

        addToFavorite.addTarget(self, action: #selector(addToFavoriteButtonDidTapped), for: .touchUpInside)
        
        chekIsFavorite(isFavorite: isFavorite)
    }
    
    func chekIsFavorite(isFavorite: Bool) {
        if isFavorite {
            addToFavorite.setBackgroundImage((UIImage(systemName: "heart.fill")), for: .normal)
        } else {
            addToFavorite.setBackgroundImage((UIImage(systemName: "heart")), for: .normal)
            addToFavorite.tintColor = .red
        }
    }
    
    
//MARK: - @objc METHODS
    
    @objc func downloadBookButtonDidTapped() {
        if !isLoadingData {
            isLoadingData = true
            viewModel?.savePDFFromFavorite()
        }
    }
    
    @objc func addToFavoriteButtonDidTapped() {
        viewModel?.removeFromFavorite()
        chekIsFavorite(isFavorite: viewModel?.isFavorite ?? false)
        self.navigationController?.popViewController(animated: true)
    }
    
//MARK: - LYFE CYCLES
    
    init(viewModel: FavoriteBookDetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        setupUIElements(model: viewModel.model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - FavoriteBookDetailViewModelDelegate

extension FavoriteBookDetailViewController: FavoriteBookDetailsViewModelDelegate {
    
    func openInWKWebView(url: String) {
        let vc = PDFController(requetURL: url)
        self.isLoadingData = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorWhileRequest() {
        let alert = UIAlertController(title: "Нестабильное интернет подключение!!!", message: "Возникла ошибка при скачивании /nПроверьте соеденение и повторите заново", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}
