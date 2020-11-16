//
//  LoginViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/2/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import KeychainSwift

class LoginViewController: NBParentViewController {

    @IBOutlet weak var passwordVisibilityButton: UIButton!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    
    var passwordIsVisible = true
    
    var loginViewModel: LoginViewModel!
    var disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel(viewController: self)
        setupView()
        
        let keychain = KeychainSwift()
        keychain.accessGroup = "123ABCXYZ.iOSAppTemplates"
        keychain.set("userName1", forKey: "userName")
        keychain.set("password1", forKey: "password")
        //loginViewModel.countryCodez()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationItem.hidesBackButton = true
    }
    
    func setupView(){
        //loginButton.setGradientBackground(horizontalMode: true)
        loginButton.roundCorners(withRadius: 6)
        _ = mobileNumberTextField.rx.text.map{ $0 ?? "" }.bind(to: loginViewModel.mobileNumber ).disposed(by: disposeBag)
        _ = passwordTextField.rx.text.map{ $0 ?? "" }.bind(to: loginViewModel.password ).disposed(by: disposeBag)
        
//        _ = loginViewModel.isValid.subscribe(onNext: { [weak self] isValid in
//            self?.showAlert(withTitle: "", andMessage: "خطأ في رقم الهاتف أو كلمة المرور")
//        }).disposed(by: disposeBag)
        
        phoneImageView.image = phoneImageView.image?.withRenderingMode(.alwaysTemplate)
        passwordImageView.image = passwordImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func forgetPasswordClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if !loginViewModel.isValidMobileNumber {
            showAlert(withTitle: "", andMessage: "رقم الهاتف يتكون من أرقام فقط ما بين ٧ إلى ٢٠ رقم")
        }else if !loginViewModel.isValidPassword{
            showAlert(withTitle: "", andMessage: "الرقم السري غير صحيح")
        }else{
            sender.isEnabled = false
            //let mobileNumber = "\(mobileNumberTextField.text ?? "")"
            let mobileNumber = "\(countryCodeLabel.text ?? "")\(mobileNumberTextField.text ?? "")"
            loginViewModel.login(withMobileNumber: mobileNumber, andPassword: passwordTextField.text ?? "")
        }
    }
    
    @IBAction func showPasswordClicked(_ sender: Any) {
        if passwordIsVisible {
            passwordIsVisible = false
            passwordVisibilityButton.setTitle("إخفاء", for: .normal)
            passwordTextField.isSecureTextEntry = false
        }else{
            passwordIsVisible = true
            passwordVisibilityButton.setTitle("إظهار", for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        goToHome()
    }
    
    
    @IBAction func onTapDropDownCountryCode(_ sender: UIButton) {
        var theValues = [String]()
        let myURLString = "https://notebooklib.com/v2/public/api/countries"
        Alamofire.request(myURLString)
            .responseJSON { response in
                print(response)
                if let result = response.result.value {
                    guard let JSON = result as? NSDictionary else {
                        return
                    }
                    if let data = JSON["data"] as? NSArray {
                        for dicz in data {
                            print(dicz)
                            let dic = dicz as! NSDictionary
                           
                            let value = "\(String(describing: dic["country_code"]!)) (\(String(describing: dic["country_phone"]!)))"
                                theValues.append(value)
                        }
                        let presenter = HGPopUpPresenter(vc: self)
                        presenter.present(.HGPopUp(withValues: theValues , AndTitle: "اختر كود الدولة"))
                    }
                }
               
                // do stuff with the JSON or error
        }
       //CountryCode.values
        print(CountryCode.values)
    }
    
}

extension LoginViewController: HGPopUpProtocol{
    func didSelectRowFromPopUp(withRow row: Int) {
        let selectedCountryCode = CountryCode.init(row: row)
        self.countryCodeLabel.text = selectedCountryCode.rawValue
    }
}
