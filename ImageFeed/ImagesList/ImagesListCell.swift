//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 30.08.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
}
