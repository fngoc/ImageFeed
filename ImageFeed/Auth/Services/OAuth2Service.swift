//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 19.11.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let session = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()   
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void) {
            let request = authTokenRequest(code: code)
            let task = object(for: request) { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    oAuth2TokenStorage.token = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        }

    // MARK: - Private methods
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    private var selfProfileRequest: URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET"
        )
    }
    
    private func profileImageURLRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET"
        )
    }
    
    private func photosRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos?"
            + "page=\(page)"
            + "&&per_page=\(perPage)",
            httpMethod: "GET"
        )
    }
    
    private func likeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
          path: "/photos/\(photoId)/like",
          httpMethod: "POST"
        )
    }
    
    private func unlikeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
          path: "/photos/\(photoId)/like",
          httpMethod: "DELETE"
        )
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

// MARK: - HTTP Request
extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

extension URLSession {
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
