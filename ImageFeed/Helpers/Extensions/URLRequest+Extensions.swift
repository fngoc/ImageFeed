//
//  URLRequest.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 21.11.2023.
//

import Foundation

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
