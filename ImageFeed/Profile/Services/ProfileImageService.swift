//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 10.12.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared: ProfileImageService = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let oauth2TokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            var request = profileImageURLRequest(username: username)
            request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
            
            assert(Thread.isMainThread)
            task?.cancel()
            
            let task = object(for: request) { [weak self] result in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.task = nil
                    switch result {
                    case .success(let body):
                        self.avatarURL = body.profileImage["small"]
                        completion(.success(self.avatarURL!))
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.didChangeNotification,
                                object: self,
                                userInfo: ["URL": self.avatarURL]
                            )
                    case .failure(let error):
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
            self.task = task
            task.resume()
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result {
                    try decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    private func profileImageURLRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com")!
        )
    }
}
