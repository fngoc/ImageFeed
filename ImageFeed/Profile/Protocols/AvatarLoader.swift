//
//  AvatarLoader.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 13.12.2023.
//

import UIKit

protocol AvatarLoader {
    
    func avatarLoad(by url: URL, setIn image: UIImageView)
}
