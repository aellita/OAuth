import Foundation
import UIKit
import WebKit


protocol AuthViewControllerDelegate: AnyObject {
    func handleTokenChanged(token: String)
}


class AuthViewController : UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let webView = WKWebView()
    private let clientID = "a1a48c963b564ec8a0e0ea78da5898ed"
    private let scheme = "myphotos"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        guard let request = request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    func setupViews() {
        
        view.backgroundColor = .gray
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private var request : URLRequest? {
        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientID)")
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}



extension AuthViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }

            if let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value {
                delegate?.handleTokenChanged(token: token)
            }
            dismiss(animated: true, completion: nil)
        }
        do {
            decisionHandler(.allow)
        }
    }
}
