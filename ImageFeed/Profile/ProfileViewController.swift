//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 13.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak private var profileLoginLabel: UILabel!
    @IBOutlet weak private var profileImageLabel: UIImageView!
    @IBOutlet weak private var profileTextLabel: UILabel!
    @IBOutlet weak private var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
        print("I AM HERE")
    }
}
