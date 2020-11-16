//
//  UpdatePasswordViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/30/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChangePasswordViewController: NBParentViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var newPasswordConfirmationVisibilityButton: UIButton!
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmationLabel: UILabel!
    @IBOutlet weak var newPasswordTextLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordVisiblityButton: UIButton!
    @IBOutlet weak var oldPasswordVisibilityButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenHeaderLabel: UILabel!
    
    @IBOutlet weak var oldPasswordImageView: UIImageView!
    @IBOutlet weak var newPasswordImageView: UIImageView!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    
    
    var oldPasswordIsVisible = false
    var newPasswordIsVisible = false
    var newPasswordConfirmationIsVisible = false
    let disposeBag = DisposeBag()
    var changePasswordVM: ChangePasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordVM = ChangePasswordViewModel.init(viewController: self)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "تعديل كلمة المرور"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        changePasswordButton.roundCorners(withRadius: 6)
        oldPasswordVisibilityButton.titleLabel?.font = UIFont.GulfRegular(withSize: FontSize.vTiny)
        changePasswordButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        oldPasswordTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        oldPasswordTextLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        titleLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        screenHeaderLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        newPasswordVisiblityButton.titleLabel?.font = UIFont.GulfRegular(withSize: FontSize.vTiny)
        newPasswordTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        newPasswordTextLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        newPasswordConfirmationVisibilityButton.titleLabel?.font = UIFont.GulfRegular(withSize: FontSize.vTiny)
        newPasswordConfirmationTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        newPasswordConfirmationLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        
        _ = oldPasswordTextField.rx.text.map{ $0 ?? "" }.bind(to: changePasswordVM.oldPassword ).disposed(by: disposeBag)
        _ = newPasswordTextField.rx.text.map{ $0 ?? "" }.bind(to: changePasswordVM.newPassword ).disposed(by: disposeBag)
        _ = newPasswordConfirmationTextField.rx.text.map{ $0 ?? "" }.bind(to: changePasswordVM.newPasswordConfirmation ).disposed(by: disposeBag)
        
        oldPasswordImageView.image = oldPasswordImageView.image?.withRenderingMode(.alwaysTemplate)
        newPasswordImageView.image = newPasswordImageView.image?.withRenderingMode(.alwaysTemplate)
        confirmPasswordImageView.image = confirmPasswordImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func passwordVisiblityButtonClicked(_ sender: UIButton) {
        oldPasswordIsVisible = !oldPasswordIsVisible
        oldPasswordTextField.isSecureTextEntry = !oldPasswordIsVisible
        if oldPasswordIsVisible {
            oldPasswordVisibilityButton.setTitle("إخفاء", for: .normal)
        }else{
            oldPasswordVisibilityButton.setTitle("إظهار", for: .normal)
        }
    }
    
    @IBAction func changePasswordButtonClicked(_ sender: UIButton) {
        if !changePasswordVM.isValidOldPassword {
            showAlert(withTitle: "", andMessage: "كلمة المرور القديمة غير صالحة")
        }else if !changePasswordVM.isValidNewPassword {
            showAlert(withTitle: "", andMessage: "كلمة المرور الجديد غير صالحة")
        }else if !changePasswordVM.isValidNewPasswordConfirmation {
            showAlert(withTitle: "", andMessage: "الرجاء مطابقة كلمة المرور")
        }else {
            if let old = oldPasswordTextField.text, let new = newPasswordTextField.text{
                changePasswordVM.changePassword(withOldPassword: old, andNewPassword: new)
            }
        }
    }
    @IBAction func newPasswordVisibilityButtonClicked(_ sender: UIButton) {
        newPasswordIsVisible = !newPasswordIsVisible
        newPasswordTextField.isSecureTextEntry = !newPasswordIsVisible
        if newPasswordIsVisible {
            newPasswordVisiblityButton.setTitle("إخفاء", for: .normal)
        }else{
            newPasswordVisiblityButton.setTitle("إظهار", for: .normal)
        }
    }
    
    func handleWrongOldPasswordEntry(){
        showAlert(withTitle: "خطأ", andMessage: "كلمة المرور القديمة خآطئة")
    }
    @IBAction func newPasswordConfirmationVisbilityButtonClicked(_ sender: UIButton) {
        newPasswordConfirmationIsVisible = !newPasswordConfirmationIsVisible
        newPasswordConfirmationTextField.isSecureTextEntry = !newPasswordConfirmationIsVisible
        if newPasswordConfirmationIsVisible {
            newPasswordConfirmationVisibilityButton.setTitle("إخفاء", for: .normal)
        }else{
            newPasswordConfirmationVisibilityButton.setTitle("إظهار", for: .normal)
        }
    }
}
