//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 30.08.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    var cellImageView: UIImageView?
    var likeButton: UIButton?
    var dateLabel: UILabel?
    
    static let reuseIdentifier = "ImagesListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadCellImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCellImageView() {
        cellImageView = UIImageView()
        
        guard let cellImageView else {
            print("UIImageView load failed")
            return
        }
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        super.addSubview(cellImageView)
        
        NSLayoutConstraint.activate([
            cellImageView.trailingAnchor.constraint(equalTo: super.trailingAnchor, constant: 16),
            cellImageView.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 16),
            cellImageView.bottomAnchor.constraint(equalTo: super.bottomAnchor, constant: 4),
            cellImageView.topAnchor.constraint(equalTo: super.topAnchor, constant: 4)
        ])
    }
}
