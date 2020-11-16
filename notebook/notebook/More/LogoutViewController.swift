//
//  logoutViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class LogoutViewController: NBParentViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var logoutVM: LogoutViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutVM = LogoutViewModel.init(viewController: self)
        setupView()
    }
    
    func setupView(){
        logoutButton.roundCorners(withRadius: 6)
        containerView.roundCorners(withRadius: 8)
    }

    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        logoutVM?.logout()
    }
    
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loggedOutSuccessfully(){
        super.removeUserData()
        MyBooksArchiver().clear()
        removeCart()
        dismiss(animated: true) {
            super.goToLogin()
        }
    }
    
    func removeCart(){
//        if let cart = NBParentViewController.realm?.objects(Cart.self) {
//            do{
//                try NBParentViewController.realm?.write {
//                    NBParentViewController.realm?.delete(cart)
//                }
//            }catch let err{
//                print(err.localizedDescription)
//            }
//        }
    }
}
