//
//  FavoriteBook+CoreDataProperties.swift
//  e-library
//
//  Created by Iskandar Fazliddinov on 17/01/23.
//
//

import Foundation
import CoreData


extension FavoriteBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteBook> {
        return NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var epub: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var linkTodownload: String?
    @NSManaged public var name: String?
    @NSManaged public var pdf: String?

}

extension FavoriteBook : Identifiable {

}
