//
//  MoreViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class MoreViewController: NBParentViewController {

    @IBOutlet weak var notLoggedInView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var interestsButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loggedInView: UIView!
    
    @IBOutlet weak var contactUsImageView: UIImageView!
    @IBOutlet weak var myAddressImageView: UIImageView!
    @IBOutlet weak var termsImageView: UIImageView!
    @IBOutlet weak var aboutNotebookImageView: UIImageView!
    @IBOutlet weak var aboutDevelopersImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.removeSearchButton()
        landingLogic()
    }
    
    func setupView(){
        interestsButton.roundCorners(withRadius: 14)
        editProfileButton.roundCorners(withRadius: 14)
        loginButton.roundCorners(withRadius: 16)
        interestsButton.titleLabel?.font = UIFont.GulfRegular(withSize: 15)
        editProfileButton.titleLabel?.font = UIFont.GulfRegular(withSize: 15)
        loginButton.titleLabel?.font = UIFont.GulfRegular(withSize: 15)
        
        contactUsImageView.image = contactUsImageView.image?.withRenderingMode(.alwaysTemplate)
        myAddressImageView.image = myAddressImageView.image?.withRenderingMode(.alwaysTemplate)
        termsImageView.image = termsImageView.image?.withRenderingMode(.alwaysTemplate)
        aboutNotebookImageView.image = aboutNotebookImageView.image?.withRenderingMode(.alwaysTemplate)
        aboutDevelopersImageView.image = aboutDevelopersImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    func landingLogic(){
        if let token = LocalStore.token(), !token.isEmpty{ // logged in
            handleLoggedInUserView()
        }else{
            handleNotLoggedInUserView()
        }
    }
    
    func handleLoggedInUserView(){
        loggedInView.isHidden = false
        notLoggedInView.isHidden = true
        usernameLabel.text = LocalStore.username()
        logoutButton.isHidden = false
    }
    
    func handleNotLoggedInUserView(){
        loggedInView.isHidden = true
        notLoggedInView.isHidden = false
        logoutButton.isHidden = true
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        goToLogin()
    }
    
    @IBAction func editInterestsButtonClicked(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Login", bundle: nil)
        if let editInterestsVC = storyBoard.instantiateViewController(withIdentifier: "UserInterestsViewController") as? UserInterestsViewController{
            editInterestsVC.isEditingUserInterests = true
            navigationController?.pushViewController(editInterestsVC, animated: true)
        }
        
    }
    
    @IBAction func myAddressButtonClicked(_ sender: UIButton) {
        if let token = LocalStore.token(), !token.isEmpty{
            performSegue(withIdentifier: "AddressSegue", sender: self)
        }else{
            loginAlert()
        }
    }
}
