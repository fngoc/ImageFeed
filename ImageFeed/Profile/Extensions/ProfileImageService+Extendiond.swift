//
//  ProfileImageService+Extendiond.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 13.12.2023.
//

import UIKit
import Kingfisher

extension ProfileImageService: AvatarLoader {
    
    func avatarLoad(by url: URL, setIn image: UIImageView) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        let cache = ImageCache.default
        
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        image.kf.indicatorType = .activity
        image.kf.setImage(with: url,
                          placeholder: UIImage(named: "placeholder.png"),
                          options: [.processor(processor)])
    }
}
