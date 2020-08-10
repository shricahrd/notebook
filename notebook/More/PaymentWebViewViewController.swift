//
//  PaymentWebViewViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/8/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import WebKit

class PaymentWebViewViewController: NBParentViewController, WKNavigationDelegate {
    
    var paymentUrl = String()
    var webKit: WKWebView?
    let successURL = "/api/return/url"
    
    
    override func loadView() {
        super.loadView()
        setupWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "الدفع"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }

    func setupWebView(){
        webKit = WKWebView()
        webKit?.navigationDelegate = self
        view = webKit
    }
    
    func setupView(){
        if let url = URL(string: paymentUrl){
            webKit?.load(URLRequest(url: url))
            webKit?.allowsBackForwardNavigationGestures = true
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("commit: \(webView.url?.absoluteString ?? "abdo")")
        if webView.url?.path == successURL{
            hideWebiewContent()
            showAlert(withTitle: "", andMessage: "تمت عملية الشراء بنجاح") { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func hideWebiewContent(){
        let whiteView = UIView.init(frame: view.frame)
        whiteView.backgroundColor = .white
        view = whiteView
    }
    
    /* http://178.62.4.69:7000/api/return/url?transaction_id=40&inv_id=51386&tx_id=1901090018458&payment_id=5caa8175bc2b4&tx_status=Initiated&mode=2&awb=1904080035564&sign=zuRkEBTdFPP328gOIrG8pqC3zV4TqVJ0p1eMQjIGHhSL1m9czg5%252FpeZcNve%252Fg0OV05DpbOqecFd0ef%252FTjXsGUhBOlRP2vBUYiqlFvjnvqrWB1LS3P3UqeE84uO6s0Kd%252B3CH5ZyZM%252FFlRlp5pfRj8GJhjzKMUkt7QrUUAryTbr4P4VYr7Gz6g6lcdi4Aw%252FufNcCX7nXXFNBW5%252F%252FV0Eh5jsxb8P40raX2WM8usnp9UVSQ%253D */
}
