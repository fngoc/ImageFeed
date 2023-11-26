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
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            if lastCode == code { return }
            task?.cancel()
            lastCode = code
            
            let request = authTokenRequest(code: code)
            let task = object(for: request) { [weak self] result in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.task = nil
                    switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.oAuth2TokenStorage.token = authToken
                        completion(.success(authToken))
                        self.lastCode = nil
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            self.task = task
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
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
