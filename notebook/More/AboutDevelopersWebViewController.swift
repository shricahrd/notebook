//
//  AboutDevelopersWebViewController.swift
//  notebook
//
//  Created by Satya on 24/08/20.
//  Copyright © 2020 clueapps. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class AboutDevelopersWebViewController: NBParentViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "عن المطورين"
        
        let url = URL(string: "https://notebooklib.com/submitbook")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addPlayButton()
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
}
