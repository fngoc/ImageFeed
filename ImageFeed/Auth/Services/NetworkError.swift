//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 20.11.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
