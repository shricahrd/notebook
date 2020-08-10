//
//  ForgetPasswordViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/31/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift

class ForgetPasswordViewController: NBParentViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sendPasswordButton: UIButton!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenHeaderLabel: UILabel!
    @IBOutlet weak var emailImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    var forgetPasswordVM: ForgetPasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPasswordVM = ForgetPasswordViewModel.init(viewController: self)
        setupView()
    }
    
    func setupView(){
        loginButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        sendPasswordButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        emailTextLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        titleLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        screenHeaderLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        emailTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
       
        sendPasswordButton.roundCorners(withRadius: 6)
        
        _ = emailTextField.rx.text.map{ $0 ?? "" }.bind(to: forgetPasswordVM.email ).disposed(by: disposeBag)
        
        emailImageView.image = emailImageView.image?.withRenderingMode(.alwaysTemplate)
    }

    @IBAction func changPasswordButtonClicked(_ sender: UIButton) {
        if !forgetPasswordVM.isValidEmail {
            showAlert(withTitle: "", andMessage: "البريد الإلكتروني غير صحيح")
        }else{
            forgetPasswordVM.forgetPassword(withEmail: forgetPasswordVM.email.value)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gotoForgetPasswordConfirmation(){
        performSegue(withIdentifier: "FPConfirmationSegue", sender: self)
    }
}
