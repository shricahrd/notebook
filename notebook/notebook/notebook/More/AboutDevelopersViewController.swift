//
//  AboutDevelopersViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class AboutDevelopersViewController: NBParentViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "عن المطورين"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addPlayButton()
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
    
        headerLabel.font =  UIFont.GulfBold(withSize: FontSize.vTiny)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    //
    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        let link = "https://www.facebook.com/clueapps/"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }

    @IBAction func websiteButtonClicked(_ sender: UIButton) {
        let link = "http://clueapps.net/"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func linkedInButtonClicked(_ sender: UIButton) {
        let link = "https://www.linkedin.com/company/clueapps/"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func behanceButtonClicked(_ sender: UIButton) {
        let link = "https://www.behance.net/ClueApps"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
    
}
