//
//  SignupViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/24/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignupViewController: NBParentViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var genderPickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var birthDataTextField: UITextField!
    
    @IBOutlet weak var nameImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var birthDateImageView: UIImageView!
    @IBOutlet weak var phoneImageview: UIImageView!
    @IBOutlet weak var mailImageView: UIImageView!
    @IBOutlet weak var passwordImageview: UIImageView!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    var passwordIsVisible = true
    var confirmPasswordIsVisible = true
    var signupViewModel: SignupViewModel!
    var disposeBag = DisposeBag()
    let dateFormatter = DateFormatter()
    let genderPickerData = ["ذكر", "انثى"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupViewModel = SignupViewModel.init(viewController: self)
        setupView()
    }
    
    func setupView(){
        //signupButton.setGradientBackground(horizontalMode: true)
        signupButton.roundCorners(withRadius: 6)
        _ = mobileNumberTextField.rx.text.map{ $0 ?? "" }.bind(to: signupViewModel.mobileNumber ).disposed(by: disposeBag)
        _ = passwordTextField.rx.text.map{ $0 ?? "" }.bind(to: signupViewModel.password ).disposed(by: disposeBag)
        _ = confirmPasswordField.rx.text.map{$0 ?? ""}.bind(to: signupViewModel.confirmPassword).disposed(by: disposeBag)
        
        _ = usernameTextField.rx.text.map{ $0 ?? "" }.bind(to: signupViewModel.username ).disposed(by: disposeBag)
        _ = genderTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.signupViewModel.gender.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = emailTextField.rx.text.map{ $0 ?? "" }.bind(to: signupViewModel.email ).disposed(by: disposeBag)
        _ = birthDataTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.signupViewModel.birthDate.value = text ?? ""
        }).disposed(by: disposeBag)
        
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Date().addingTimeInterval(60 * 60 * 24 * 365 * -100)
        dateFormatter.dateFormat = "YYYY-MM-dd"
       // birthDataTextField.text = dateFormatter.string(from: datePicker.date)
         birthDataTextField.text = ""
        
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        //genderTextField.text = genderPickerData.first
        genderTextField.text = "حدد نوع الجنس"
        
        nameImageView.image = nameImageView.image?.withRenderingMode(.alwaysTemplate)
        genderImageView.image = genderImageView.image?.withRenderingMode(.alwaysTemplate)
        birthDateImageView.image = birthDateImageView.image?.withRenderingMode(.alwaysTemplate)
        phoneImageview.image = phoneImageview.image?.withRenderingMode(.alwaysTemplate)
        mailImageView.image = mailImageView.image?.withRenderingMode(.alwaysTemplate)
        passwordImageview.image = passwordImageview.image?.withRenderingMode(.alwaysTemplate)
        confirmPasswordImageView.image = confirmPasswordImageView.image?.withRenderingMode(.alwaysTemplate)
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        genderPickerView.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        
        if !signupViewModel.isValidUsername{
            showAlert(withTitle: "", andMessage: "اسم المستخدم غير صحيح")
        }
//        else if !signupViewModel.isValidGender{
//            showAlert(withTitle: "", andMessage: "اختر الجنس")
//        }else if !signupViewModel.isValidBirthDate{
//            showAlert(withTitle: "", andMessage: "تاريخ الميلاد غير صالح")
//        }
        else if !signupViewModel.isValidMobileNumber {
            showAlert(withTitle: "", andMessage: "رقم الهاتف يتكون من أرقام فقط ما بين ٧ إلى ٢٠ رقم")
        }else if !signupViewModel.isValidEmail{
            showAlert(withTitle: "", andMessage: "البريد الإلكتروني غير صالح")
        }else if !signupViewModel.isValidPassword{
            showAlert(withTitle: "", andMessage: "الرقم السري غير صحيح")
        }else if !signupViewModel.isValidConfirmPassword{
            showAlert(withTitle: "", andMessage: "تأكيد الرقم السري غير صحيح")
        }else if !signupViewModel.isPasswordAndConfirmPasswordIdentical{
            showAlert(withTitle: "", andMessage: "يجب ان يكون الرقم السري و تأكيد الرقم السري متشابهان")
        }else{
            sender.isEnabled = false
            let mobileNumber = "\(countryCodeLabel.text ?? "")\(signupViewModel.mobileNumber.value)"
            signupViewModel.signup(withUsername: signupViewModel.username.value, andGender: signupViewModel.gender.value, andMobileNumber: mobileNumber, andEmail: signupViewModel.email.value, andBirthDate: signupViewModel.birthDate.value, andPassword: signupViewModel.password.value)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPasswordButtonClicked(_ sender: UIButton) {
        if passwordIsVisible {
            passwordIsVisible = false
            showPasswordButton.setTitle("إخفاء", for: .normal)
            passwordTextField.isSecureTextEntry = false
        }else{
            passwordIsVisible = true
            showPasswordButton.setTitle("إظهار", for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func showConfirmPasswordButtonClicked(_ sender: UIButton) {
        if confirmPasswordIsVisible {
            confirmPasswordIsVisible = false
            showConfirmPasswordButton.setTitle("إخفاء", for: .normal)
            confirmPasswordField.isSecureTextEntry = false
        }else{
            confirmPasswordIsVisible = true
            showConfirmPasswordButton.setTitle("إظهار", for: .normal)
            confirmPasswordField.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func birthDateButtonClicked(_ sender: UIButton) {
       showbirthdatePicker()
    }
    
    func showbirthdatePicker(){
        UIView.transition(with: datePicker, duration: 0.2, options: .transitionCrossDissolve, animations: {
            if self.datePicker.isHidden {
                self.datePicker.isHidden = false
                self.datePickerHeightConstraint.constant = 216
            }else{
                self.datePicker.isHidden = true
                self.datePickerHeightConstraint.constant = 0
            }
        })
    }
    
    @IBAction func datePickerDidChange(_ sender: UIDatePicker) {
        birthDataTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func gotoInterests(){
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        if let interestsVC = storyboard.instantiateViewController(withIdentifier: "UserInterestsViewController") as? NBParentViewController{
            self.present(interestsVC, animated: true, completion: nil)
        }
    }
    @IBAction func pickGenderButtonClicked(_ sender: UIButton) {
        showGenderPicker()
    }
    
    func showGenderPicker(){
        UIView.transition(with: datePicker, duration: 0.2, options: .transitionCrossDissolve, animations: {
            if self.genderPickerView.isHidden {
                self.genderPickerView.isHidden = false
                self.genderPickerViewHeightConstraint.constant = 216
            }else{
                self.genderPickerView.isHidden = true
                self.genderPickerViewHeightConstraint.constant = 0
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerData.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return genderPickerData[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedGender = genderPickerData[row]
        genderTextField.text = selectedGender
        showGenderPicker()
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        attributedString = NSAttributedString(string: genderPickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        return attributedString
    }
  
    
    @IBAction func onTapDropDownCountryCode(_ sender: UIButton) {
        let presenter = HGPopUpPresenter(vc: self)
        presenter.present(.HGPopUp(withValues: CountryCode.values, AndTitle: "اختر كود الدولة"))
    }
    
}

extension SignupViewController: HGPopUpProtocol{
    func didSelectRowFromPopUp(withRow row: Int) {
        let selectedCountryCode = CountryCode.init(row: row)
        self.countryCodeLabel.text = selectedCountryCode.rawValue
    }
}
