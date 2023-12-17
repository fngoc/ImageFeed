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
        tabBarControllersLoad()
        tabBarUILoad()
    }
    
    private func tabBarUILoad() {
        tabBar.backgroundColor = .myBlack
        tabBar.unselectedItemTintColor = .myGray
        tabBar.tintColor = .myWhite
    }
    
    private func tabBarControllersLoad() {
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "main_page_active"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "profile_page_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
