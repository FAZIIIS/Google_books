//
//  CoreDataManager.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 12/01/23.
//

import Foundation
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var favoriteBook = [FavoriteBook]()
    
    weak var delegate: CoreDataDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() {
        
        do {
            favoriteBook = try context.fetch(FavoriteBook.fetchRequest())
            delegate?.updateData()
        } catch {
            print("Не удалось обновить данные с кэша")
        }
    }
    
    func saveFavoriteBook(item: SearchedBokInfo) {
        let newFavoriteBook = FavoriteBook(context: context)
        var authors = ""
        
        item.volumeInfo?.authors?.forEach { author in
            authors.append("\(author) \n")
        }
        
        newFavoriteBook.id = item.id
        newFavoriteBook.author = authors
        newFavoriteBook.bookDescription = item.volumeInfo?.description
        newFavoriteBook.name = item.volumeInfo?.title
        newFavoriteBook.image = item.volumeInfo?.imageLinks?.thumbnail
        newFavoriteBook.isFavorite = true
        newFavoriteBook.epub = item.accessInfo?.epub?.acsTokenLink ?? ""
        newFavoriteBook.epub = item.accessInfo?.pdf?.acsTokenLink ?? ""
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Не удалось сохранить книгу в избранные")
        }
    }
    
    func deleteFromFavoriteBook(item: FavoriteBook) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Не удалось удалить книгу с избранных")
        }
    }
}
