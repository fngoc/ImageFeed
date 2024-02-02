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
    
    func isAuthorized() -> Bool {
        return oAuth2TokenStorage.token != nil
    }
    
    func getToken() -> String {
        guard let token = oAuth2TokenStorage.token else {
            print("Something wrong with token in tokenStorage")
            return ""
        }
        return token
    }
    
    func logOut() {
        oAuth2TokenStorage.removeKeychain()
    }

    // MARK: - Private methods
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
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
