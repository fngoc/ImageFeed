//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 20.11.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
