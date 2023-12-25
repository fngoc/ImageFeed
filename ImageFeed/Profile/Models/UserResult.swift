//
//  UserResult.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 10.12.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: [String:String]
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
