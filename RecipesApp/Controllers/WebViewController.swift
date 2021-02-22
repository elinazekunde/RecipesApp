//
//  WebViewController.swift
//  RecipesApp
//
//  Created by Elīna Zekunde on 22/02/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var url = String()
    
    @IBOutlet var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start nav")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("nav stopped")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        
        
        // Pass the selected object to the new view controller.
    }
 */
}
