//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 13.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var imageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
        updateAvatar()
        
        view.backgroundColor = UIColor.myBlack
        
        imageViewLoad()
        nameLabelLoad()
        loginLabelLoad()
        textLabelLoad()
        logoutButtonLoad()
        
        constraintsLoad()
        
        updateProfileDetails(profile: profileService.profile ?? Profile(
            username: "Нет логина",
            loginName: "Нет логина",
            name: "Нет имени",
            bio: "Нет описания")
        )
    }
    
    // MARK: - Actions
    @objc
    private func didTapLogoutButton(_ sender: UIButton) {
        print("Tap logout button")
    }
    
    func updateProfileDetails(profile: Profile) {
        self.nameLabel?.text = profile.name
        self.loginLabel?.text = profile.loginName
        self.descriptionLabel?.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO: avatar load
    }
    
    // MARK: - Private Load UI
    private func logoutButtonLoad() {
        self.logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(Self.didTapLogoutButton(_:))
        )
        
        guard let logoutButton else {
            print("Logout button load failed")
            return
        }
        
        logoutButton.tintColor = UIColor.myRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
    }
    
    private func textLabelLoad() {
        self.descriptionLabel = UILabel()
        
        guard let descriptionLabel else {
            print("Text label load failed")
            return
        }
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor.myWhite
        descriptionLabel.font = UIFont(name: "SF Pro", size: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }
    
    private func loginLabelLoad() {
        self.loginLabel = UILabel()
        
        guard let loginLabel else {
            print("Login label load failed")
            return
        }
        
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor.myGray
        loginLabel.font = UIFont(name: "SF Pro", size: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
    }
    
    private func nameLabelLoad() {
        self.nameLabel = UILabel()
        
        guard let nameLabel else {
            print("Name label load failed")
            return
        }
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor.myWhite
        nameLabel.font = UIFont(name: "SF Pro Bold", size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func imageViewLoad() {
        self.imageView = UIImageView(image: UIImage(named: "Photo"))
        
        guard let imageView else {
            print("Image view load failed")
            return
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    // MARK: - Private Load Constraints
    private func constraintsLoad() {
        guard let imageView, let nameLabel, let loginLabel,
              let descriptionLabel, let logoutButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
