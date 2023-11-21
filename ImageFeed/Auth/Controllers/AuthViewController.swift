//
//  AuthController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 12.11.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    @IBOutlet private weak var authButton: UIButton!
    private var logoImageView: UIImageView?
    private var oAuth2Service: OAuth2Service?
    
    weak var delegate: AuthViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        oAuth2Service = OAuth2Service()
        view.backgroundColor = UIColor.myBlack
        
        imageViewLoad()
        buttonLoad()
        constraintsLoad()
    }
    
    // MARK: - Actions
    @IBAction func didTouchAuthButton(_ sender: UIButton) {
        print("Tap to login")
    }
    
    // MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Load UI
    private func buttonLoad() {
        guard let authButton else {
            print("Button load failed")
            return
        }
        
        authButton.setTitle("Войти", for: .normal)
        authButton.titleLabel?.font = UIFont(name: "SF Pro Bold", size: 17)
        authButton.setTitleColor(.myBlack, for: .normal)
        authButton.backgroundColor = UIColor.myWhite
        authButton.layer.masksToBounds = true
        authButton.layer.cornerRadius = 16
        authButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authButton)
    }
    
    private func imageViewLoad() {
        logoImageView = UIImageView(image: UIImage(named: "auth_screen_logo"))
        
        guard let logoImageView else {
            print("Image view load failed")
            return
        }
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
    }
    
    // MARK: - Private Load Constraints
    private func constraintsLoad() {
        guard let logoImageView, let authButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            authButton.heightAnchor.constraint(equalToConstant: 48),
            authButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            authButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

// MARK: - WebViewViewControllerDelegate Extension
extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
