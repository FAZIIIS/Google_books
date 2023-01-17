//
//  FavoritesScreenViewModel.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 01/01/23.
//

import Foundation
import UIKit

class FavoritesScreenViewModel {
    
    var localManager = CoreDataManager.shared
    
    func numberOfRows() -> Int {
        return localManager.favoriteBook.count
    }
}
