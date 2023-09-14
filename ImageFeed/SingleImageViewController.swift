//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 14.09.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
