//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 26.08.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    
    private let imagesListService = ImagesListService.shared
    private let photoName: [String] = Array(0..<20).map { "\($0)" }
    private let showSingleImageIdentificator = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableViewLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentificator {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func tableViewLoad() {
        tableView = UITableView()
        
        guard let tableView else {
            print("UITableView load failed")
            return
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.backgroundColor = .myBlack
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photoName[indexPath.row]) else {
            return
        }
        
        cell.cellImageView.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let like: String = indexPath.row % 2 == 0 ? "Active Like" : "No Active Like"
        if let likeImage = UIImage(named: like) {
            cell.likeButton.setImage(likeImage, for: .normal)
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentificator, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photoName[indexPath.row]) else {
            return 0
        }
        
        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageWight = image.size.width
        let imageViewWight = tableView.bounds.width - insets.left - insets.right
        let scale = imageViewWight / imageWight
        let cellHeight = image.size.height * scale + insets.top + insets.bottom
        return cellHeight
    }
}
