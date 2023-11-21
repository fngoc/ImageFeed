//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 19.11.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let userDefault = UserDefaults.standard
    
    var token: String? {
        get {
            userDefault.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefault.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
