//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 13.12.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        awakeFromNib()
        tabBarUILoad()
    }
    
    override func awakeFromNib() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "profile_page_active"),
            selectedImage: nil
        )

        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    // MARK: - Private methods
    private func tabBarUILoad() {
        tabBar.backgroundColor = .myBlack
        tabBar.barTintColor = .myBlack
        tabBar.unselectedItemTintColor = .myGray
        tabBar.tintColor = .myWhite
    }
}
