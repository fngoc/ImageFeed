//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 10.12.2023.
//

import Foundation

final class ProfileService {
    
    static let shared: ProfileService = ProfileService()
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void) {
        var request = makeProfileRequest()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                    self.profile = self.convertToProfile(src: body)
                    completion(.success(self.convertToProfile(src: body)))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeProfileRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: URL(string: Constants.apiUrl)!
        )
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }

    private func convertToProfile(src: ProfileResult) -> Profile {
        return Profile(
            username: src.username,
            loginName: "@\(src.username)",
            name: "\(src.firstName) \(src.lastName ?? "")",
            bio: src.bio ?? "Нет описания"
        )
    }
}
