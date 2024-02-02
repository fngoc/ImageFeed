//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 27.12.2023.
//

import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
