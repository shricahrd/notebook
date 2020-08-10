//
//  ForgetPasswordConfirmationViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/31/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift

class ForgetPasswordConfirmationViewController: NBParentViewController {

    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var passwordConfirmationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTitleLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenHeaderLabel: UILabel!
    
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var newPasswordImageView: UIImageView!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    
    
    let disposeBag = DisposeBag()
    var forgetPasswordConfirmationnVM: ForgetPasswordConfirmationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPasswordConfirmationnVM = ForgetPasswordConfirmationViewModel.init(viewController: self)
        setupView()
    }
    
    func setupView(){
        changePasswordButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        backButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        codeTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        titleLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        screenHeaderLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        codeTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        newPasswordTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        newPasswordTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        passwordConfirmationTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        passwordConfirmationLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
       
        changePasswordButton.roundCorners(withRadius: 6)
        
        _ = codeTextField.rx.text.map{ $0 ?? "" }.bind(to: forgetPasswordConfirmationnVM.code ).disposed(by: disposeBag)
        _ = newPasswordTextField.rx.text.map{ $0 ?? "" }.bind(to: forgetPasswordConfirmationnVM.newPassword ).disposed(by: disposeBag)
        _ = passwordConfirmationTextField.rx.text.map{ $0 ?? "" }.bind(to: forgetPasswordConfirmationnVM.passwordConfirmation ).disposed(by: disposeBag)
        
        
        codeImageView.image = codeImageView.image?.withRenderingMode(.alwaysTemplate)
        newPasswordImageView.image = newPasswordImageView.image?.withRenderingMode(.alwaysTemplate)
        confirmPasswordImageView.image = confirmPasswordImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func forgetPasswordButtonClicked(_ sender: UIButton) {
        if !forgetPasswordConfirmationnVM.isValidCode {
            showAlert(withTitle: "", andMessage: "برجاء إدخال الكود")
        }else if !forgetPasswordConfirmationnVM.isValidPassword{
            showAlert(withTitle: "", andMessage: "الرقم السري غير صالح")
        }else if !forgetPasswordConfirmationnVM.isValidPasswordConfirmation{
            showAlert(withTitle: "", andMessage: "برجاء مطابقة كلمة المرور")
        }else{
            forgetPasswordConfirmationnVM.forgetPassword(withCode: forgetPasswordConfirmationnVM.code.value, andPassword: forgetPasswordConfirmationnVM.newPassword.value)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
