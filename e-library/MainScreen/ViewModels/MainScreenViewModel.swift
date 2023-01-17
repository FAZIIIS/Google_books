//
//  MainScreenViewModel.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 01/01/23.
//

import Foundation

protocol RequestResult {
    func inSucces(dataFromServer: [SearchedBokInfo])
    func startLoadingAnimating()
    func showError()
    func showWaitWindow()
    func hideWaitWindow()
}

class MainScreenViewModel {
    
//MARK: - PROPERTIES
    
    var books = [SearchedBokInfo]()
    var filteredBooks = [String]()
    var delegate: RequestResult?
    var isEmpty = true
    var filterText = "SwiftUI"
    private var isLoadingData = false
    private var favoriteStatus = false
    private let localManager = CoreDataManager.shared
    var isPagination = false
    

//MARK: - METHODS
    
    func getDataWithPagination(indexPath: Int, text: String) {
        
        if indexPath == books.count - 2 && !isLoadingData {
            isPagination = true
            NetworkManager.shared.startIndex += 1
            self.delegate?.startLoadingAnimating()
            isLoadingData = true
            getBooks(search: text)
        }
    }
    
    func getBooks(search: String) {
        
        if !isPagination {
            DispatchQueue.main.async { self.delegate?.showWaitWindow() }
        }
        
        var requestManager = NetworkManager.shared
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 2) {
            
            requestManager.request(url: search) { [weak self] result in
                
                switch result {
    
                case .success(let data):
                    
                    data.items?.forEach { item in
                        
                        //remove empty data
                        if item.volumeInfo?.description == nil || item.volumeInfo?.authors == nil || item.volumeInfo?.imageLinks == nil {
                            return
                        }
                        
                        //remove duplicates
                        if !(self?.filteredBooks.contains(item.id ?? "") ?? false) {
                            self?.filteredBooks.append(item.id ?? "")
                            self?.books.append(item)
                        }
                    }
                    
                    guard let books = self?.books else { return }
                    
                    DispatchQueue.main.async { self?.delegate?.hideWaitWindow() }
                    
                    DispatchQueue.main.async { self?.delegate?.inSucces(dataFromServer: books) }
    
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Возникла ошибка при запросе \(error)")
                        self?.delegate?.showError()
                    }
                }
            }
        }
        isLoadingData = false
    }
    
    func numberOfRowsInSection() -> Int {
        return books.count
    }
    
    func isFavorite(model: SearchedBokInfo) -> Bool {
        var status = false
        localManager.getAllItems()
        
        localManager.favoriteBook.forEach { favorite in
            if favorite.id ?? "" == model.id ?? "" {
                status = true
                favoriteStatus = true
            }
        }
        
        return status
    }
}
