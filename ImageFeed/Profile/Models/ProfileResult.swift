//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 10.12.2023.
//

import Foundation

struct ProfileResult: Codable {
    
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
