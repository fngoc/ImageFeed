//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 19.11.2023.
//

import SwiftKeychainWrapper
import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let keychain = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychain.string(forKey: Keys.token.rawValue)
        }
        set {
            guard
                let newValue = newValue,
                keychain.set(newValue, forKey: Keys.token.rawValue)
                
            else {
                print("Token not save in keychain")
                return
            }
        }
    }
    
    static func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
