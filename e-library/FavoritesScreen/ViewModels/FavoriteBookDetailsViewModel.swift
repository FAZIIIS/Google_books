//
//  FavoriteBookDetailsViewModel.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 15/01/23.
//

import Foundation


protocol FavoriteBookDetailsViewModelDelegate: AnyObject {
    func openInWKWebView(url: String)
    func showErrorWhileRequest()
}

class FavoriteBookDetailsViewModel {
    
//MARK: - PROPERTIES
    
    let model: FavoriteBook
    var localManager = CoreDataManager.shared
    var isFavorite = true
    var delegate: FavoriteBookDetailsViewModelDelegate?
    
//MARK: - METHODS
    
    func removeFromFavorite() {
        localManager.deleteFromFavoriteBook(item: model)
        isFavorite = false
    }
    
    func savePDFFromFavorite() {
        let request = NetworkManager.shared
        var url = ""
        
        if let epub = model.epub {
            url = epub
        } else if let pdf = model.pdf {
            url = pdf
        }
        
        guard let fileName = model.name else { return }
        
        DispatchQueue.global(qos: .default).async {
            request.savePdf(urlString: url, fileName: fileName) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.delegate?.openInWKWebView(url: url)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.delegate?.showErrorWhileRequest()
                    }
                }
            }
        }
    }
    
//MARK: INIT
    
    init(model: FavoriteBook) {
        self.model = model
    }
}
