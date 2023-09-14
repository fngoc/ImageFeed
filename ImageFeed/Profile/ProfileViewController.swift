//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 13.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var profileLoginLabel: UILabel!
    @IBOutlet private weak var profileImageLabel: UIImageView!
    @IBOutlet private weak var profileTextLabel: UILabel!
    @IBOutlet private weak var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
        print("I AM HERE")
    }
}
