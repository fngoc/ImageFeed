//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Виталий Хайдаров on 12.11.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    private var webView: WKWebView?
    private var progressView: UIProgressView?
    private var backButton: UIButton?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewLoad()
        buttonLoad()
        progressViewLoad()
        
        estimatedProgressObservation = webView?.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             }
        )
        updateProgress()
    }
    
    // MARK: - Actions
    @objc
    private func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Private methods
    private func updateProgress() {
        guard let progressView,
              let webView
        else {
            print("ProgressView or webView load failed")
            return
        }
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs((webView.estimatedProgress) - 1.0) <= 0.0001
    }
    
    private func webViewLoad() {
        webView = WKWebView()
        
        guard let webView else {
            print("WebView load failed")
            return
        }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func progressViewLoad() {
        progressView = UIProgressView()
        
        guard let progressView,
              let backButton
        else {
            print("ProgressView load failed")
            return
        }
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .myBlack
        
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10)
        ])
    }
    
    private func buttonLoad() {
        backButton = UIButton.systemButton(
            with: UIImage(named: "nav_back_button")!,
            target: self,
            action: #selector(Self.didTapBackButton(_:))
        )
        
        guard let backButton else {
            print("BackButton load failed")
            return
        }
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.tintColor = .myBlack
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11)
        ])
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
