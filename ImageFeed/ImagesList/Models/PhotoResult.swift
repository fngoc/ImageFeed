//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 27.12.2023.
//

import Foundation

struct PhotoResult: Codable {
    
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: String
    let height: String
    let color: String
    let blurHash: String
    let likes: String
    let likedByUser: String
    let description: String
    let user: String
    let urls: [UrlsResult]
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case blurHash = "blur_hash"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
        case user = "user"
        case urls = "urls"
    }
}