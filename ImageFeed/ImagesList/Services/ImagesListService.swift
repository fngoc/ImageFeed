//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 27.12.2023.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        if task == nil {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            
            fetchPhoto(nextPage) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let photo):
                    photos.append(photo)
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: nil //TODO: не понятно
                        )
                    print("PHOTOS: \(photos)")
                case .failure:
                    print("Photos not load")
                    break
                }
            }
        }
    }
    
    private func fetchPhoto(_ nextPage: Int, completion: @escaping (Result<Photo, Error>) -> Void) {
        let task = object(
            for: photosRequest(page: nextPage, perPage: 10)
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.task = nil
                switch result {
                case .success(let body):
                    let photos = self.convertPhotoResultToPhoto(body)
                    completion(.success(photos))
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
        completion: @escaping (Result<PhotoResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<PhotoResult, Error> in
                Result {
                    try decoder.decode(PhotoResult.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    private func convertPhotoResultToPhoto(_ photoResult: PhotoResult) -> Photo {
        return Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width) ?? 0, height: Double(photoResult.height) ?? 0),
            createdAt: Date(),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.first?.thumb ?? "",
            largeImageURL: photoResult.urls.first?.full ?? "",
            isLiked: photoResult.likes.isEmpty
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
}
