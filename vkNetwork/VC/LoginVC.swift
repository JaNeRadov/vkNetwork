//
//  ViewController.swift
//  vkNetwork
//
//  Created by Jane Z. on 31.08.2022.
//

import UIKit
import WebKit

class LoginVC: UIViewController {
    @IBOutlet weak var loginWebView: WKWebView! {
        didSet {
            loginWebView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: "8214357"),
        URLQueryItem(name: "display", value: "mobile"),
        URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
        URLQueryItem(name: "scope", value: "262150"),
        URLQueryItem(name: "response_type", value: "token"),
        URLQueryItem(name: "v", value: "5.68")]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        
        loginWebView.load(request)
    }


}

extension LoginVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment else {
                  decisionHandler(.allow)
                  return
              }
        
        let parms = fragment
            .components(separatedBy: "&")
            .map({ $0.components(separatedBy: "=")})
            .reduce([String: String]()) { result, parm in
                var dict = result
                let key = parm[0]
                let value = parm[1]
                dict[key] = value
                return dict
            }
        
        if let token = parms["access_token"] {
            Session.instance.token = token
            
        }
    }
}
