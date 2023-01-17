//
//  BookDetailsViewModel.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 06/01/23.
//

import Foundation
import SafariServices

protocol BookDetailsViewModelProtocol: AnyObject {
    func showErrorWhileRequest()
    func openInWKWebView(urlForOpen: String)
}

class BookDetailsViewModel {

//MARK: PROPERTIES
    
    var model: SearchedBokInfo
    var request = NetworkManager.shared
    var authors = ""
    weak var delegate: BookDetailsViewModelProtocol?
    var localManager = CoreDataManager.shared
    var isFavorite = false
    
    
//MARK: - METHODS
    
    func savePDF() {
        let request = NetworkManager.shared
        var url = ""
        
        if let epub = model.accessInfo?.epub?.acsTokenLink {
            url = epub
        } else if let pdf = model.accessInfo?.pdf?.acsTokenLink {
            url = pdf
        }
        
        guard let fileName = model.volumeInfo?.title else { return }
        
        DispatchQueue.global(qos: .default).async {
            request.savePdf(urlString: url, fileName: fileName) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.delegate?.openInWKWebView(urlForOpen: url)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.delegate?.showErrorWhileRequest()
                    }
                }
            }
        }
    }
    
    func addBookToFavorite() {
        if isFavorite {
            localManager.favoriteBook.forEach { item in
                if item.id == self.model.id ?? "" {
                    localManager.deleteFromFavoriteBook(item: item)
                    isFavorite = false
                }
            }
        } else {
            localManager.saveFavoriteBook(item: model)
            isFavorite = true
        }
    }
    
//MARK: - INIT
    
    init(model: SearchedBokInfo) {
        self.model = model
    }
}
