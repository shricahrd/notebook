//
//  AboutNoteBookViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class AboutNoteBookViewController: NBParentViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "عن نوت بوك"
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
    
    @IBAction func websiteButtonClicked(_ sender: UIButton) {
        let link = "http://notebooklib.com"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func mailButtonClicked(_ sender: UIButton) {
        let link = "mailto:note_books@outlook.com"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func instaButtonClicked(_ sender: UIButton) {
        let link = "https://instagram.com/dar_notebook?utm_source=ig_profile_share&igshid=st1dsl3nlr5z"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func twitterButtonClicked(_ sender: UIButton) {
        let link = "https://twitter.com/dar_notebook"
        if let url = URL.init(string: link){
            UIApplication.shared.open(url)
        }
    }
}
