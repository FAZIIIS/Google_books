//
//  SearchModel.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 03/01/23.
//

import Foundation

struct SearchBaseModel: Codable {
    let items: [SearchedBokInfo]?
    let kind: String?
    let totalItems: Int?
}

struct SearchedBokInfo: Codable {
    let kind: String?
    let id: String?
    let etag: String?
    let volumeInfo: BookInfo?
    let accessInfo: BookDownloadAttrebutes?
    let isFavorite: Bool?
}

struct BookInfo: Codable {
    let title: String?
    let authors: [String]?
    let imageLinks: BookImageLinks?
    let previewLink: String?
    let description: String?
    let canonicalVolumeLink: String?
}

struct BookDownloadAttrebutes: Codable {
    let epub: BookDownloadLink?
    let pdf: BookDownloadLink?
}

struct BookDownloadLink: Codable {
    let isAvailable: Bool?
    let downloadLink: String?
    let acsTokenLink: String?
}

struct BookImageLinks: Codable {
    let thumbnail: String?
}
