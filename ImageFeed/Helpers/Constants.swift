//
//  Constants.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 11.11.2023.
//

import Foundation

struct Constants {
    
    static let accessKey: String = "CN-XSAOp91q73hlhPpeSCjCfFYtE8bxFPF9AMYqLyXY"
    static let secretKey: String = "F9wMgszYjA0PcdXXicgmMuAm_UB-I6bA0f7UO6TTryw"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
