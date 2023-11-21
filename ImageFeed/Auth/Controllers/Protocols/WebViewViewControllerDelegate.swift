//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 12.11.2023.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
