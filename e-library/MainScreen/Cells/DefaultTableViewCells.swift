//
//  DefaultTableViewCells.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 03/01/23.
//

import Foundation
import UIKit
import SnapKit


class DefaultTableViewCells: UITableViewCell {
    
//MARK: - PROPERTIES
    
    static let ID = "DefaultTableViewCells"
    var authors = ""
    var isFavorite = false
    var model: SearchedBokInfo?
    var favoriteModel: FavoriteBook?
    
    
//MARK: - UI ELEMENTS
    
    private var icon: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private var bookName: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 16)
        view.numberOfLines = 0
        
        return view
    }()
    
    private var authorName: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .gray
        view.font = .systemFont(ofSize: 12)
        view.numberOfLines = 0
        
        return view
    }()
    
    private var bookDescription: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 12)
        view.numberOfLines = 3
        
        return view
    }()
    
    var favoriteIcon: UIButton = {
        var view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
//MARK: - METHODS
    
    func configureCell(model: SearchedBokInfo, tag: Int) {
        let request = NetworkManager.shared
        
        guard let link = model.volumeInfo?.imageLinks?.thumbnail else { return }
                
        self.bookName.text = model.volumeInfo?.title ?? ""
        
        model.volumeInfo?.authors?.forEach { author in
            self.authors.removeAll()
            self.authors.append("\(author) \n")
        }
        
        self.authorName.text = self.authors
        self.bookDescription.text = model.volumeInfo?.description ?? ""
        
        request.downloadImage(URLAddress: link) { imageFromServer in
            self.icon.image = imageFromServer
        }
        
        self.favoriteIcon.tag = tag
        self.model = model
        
        setupFavoriteIconState(isFavorite: self.isFavorite)
        favoriteIcon.addTarget(self, action: #selector(addToFavoriteButtonDidTapped), for: .touchUpInside)
    }
    
    func configureCell(model: FavoriteBook) {
        let request = NetworkManager.shared
        
        self.bookName.text = model.name ?? ""
        self.authorName.text = model.author ?? ""
        self.bookDescription.text = model.bookDescription ?? ""
        
        request.downloadImage(URLAddress: model.image ?? "") { imageFromServer in
            self.icon.image = imageFromServer
        }
        
        setupFavoriteIconState(isFavorite: model.isFavorite)
        favoriteIcon.addTarget(self, action: #selector(removeFromFavorite), for: .touchUpInside)
        self.favoriteModel = model
        
    }
    
    func setupFavoriteIconState(isFavorite: Bool) {
        if isFavorite {
            self.favoriteIcon.tintColor = .red
            self.favoriteIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.favoriteIcon.tintColor = .blue
            self.favoriteIcon.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func setupUIElements() {
        
        contentView.addSubview(icon)
        contentView.addSubview(bookName)
        contentView.addSubview(authorName)
        contentView.addSubview(bookDescription)
        contentView.addSubview(favoriteIcon)
        
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(60)
        }
        
        favoriteIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(26)
        }
        
        bookName.snp.makeConstraints { make in
            make.left.equalTo(icon.snp_rightMargin).offset(18)
            make.top.equalToSuperview().offset(16)
            make.right.equalTo(favoriteIcon.snp_leftMargin).offset(-16)
        }
        
        authorName.snp.makeConstraints { make in
            make.left.right.equalTo(bookName)
            make.top.equalTo(bookName.snp_bottomMargin).offset(18)
        }
        
        bookDescription.snp.makeConstraints { make in
            make.left.right.equalTo(bookName)
            make.top.equalTo(authorName.snp_bottomMargin).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    
//MARK: - @objc METHODS
    
    @objc func addToFavoriteButtonDidTapped() {
        let localManager = CoreDataManager.shared
        guard let model = model else { return }
        if isFavorite {
            localManager.favoriteBook.forEach { item in
                if item.id == self.model?.id ?? "" {
                    localManager.deleteFromFavoriteBook(item: item)
                    isFavorite = false
                    setupFavoriteIconState(isFavorite: isFavorite)
                }
            }
        } else {
            localManager.saveFavoriteBook(item: model)
            isFavorite = true
            setupFavoriteIconState(isFavorite: isFavorite)
        }
        print("its work")
    }
    
    @objc func removeFromFavorite() {
        guard let favoriteModel = favoriteModel else { return }

        let localManager = CoreDataManager.shared
        localManager.deleteFromFavoriteBook(item: favoriteModel)
        
    }
    
    
//MARK: - INIT
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
