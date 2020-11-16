//
//  EditProfileViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: NBParentViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var usernameTitleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameImageView: UIImageView!
    
    @IBOutlet weak var birthDataTitleLabel: UILabel!
    @IBOutlet weak var birthDataTextField: UITextField!
    @IBOutlet weak var birthDateImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewOfDatePicker: UIView!
    @IBOutlet weak var donePickingBirthdateButton: UIButton!
    
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var viewOfGenderPicker: UIView!
    @IBOutlet weak var donePickingGenderButton: UIButton!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var mobileNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneImageview: UIImageView!
    
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailImageView: UIImageView!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var editPasswordButton: UIButton!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var editProfileVM: EditProfileViewModel!
    var isGoodToGo = Variable<Bool>(false)
    let genderPickerData = ["ذكر", "انثى"]
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileVM = EditProfileViewModel.init(viewController: self)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "تعديل البيانات"
        
        usernameTextField.text = LocalStore.username()
        editProfileVM.userName.value = LocalStore.username() ?? ""
        
        genderTextField.text = (LocalStore.gender() == "male" ? "ذكر" : "انثى")
        editProfileVM.gender.value = (LocalStore.gender() == "male" ? "ذكر" : "انثى")
        
        birthDataTextField.text = LocalStore.birthdate()
        editProfileVM.birthDate.value = LocalStore.birthdate() ?? ""
        
        emailTextField.text = LocalStore.email()
        editProfileVM.email.value = LocalStore.email() ?? ""
        
        let phoneNumberAndCountryCode = LocalStore.phoneNumberAndCountryCode(from: LocalStore.phoneNumber() ?? "")
        countryCodeLabel.text = phoneNumberAndCountryCode.0
        editProfileVM.countryCode.value = phoneNumberAndCountryCode.0
        mobileNumberTextField.text = phoneNumberAndCountryCode.1
        editProfileVM.mobileNumber.value = phoneNumberAndCountryCode.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addPlayButton()
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        editPasswordButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.tiny)
        editPasswordButton.roundCorners(withRadius: 6)
        
        saveChangesButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.tiny)
        saveChangesButton.roundCorners(withRadius: 6)
        
        usernameTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        usernameTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        
        birthDataTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        birthDataTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        donePickingBirthdateButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.tiny)
        
        genderTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        genderTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        donePickingGenderButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.tiny)
        
        mobileNumberTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        mobileNumberTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        
        emailTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        emailTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Date().addingTimeInterval(60 * 60 * 24 * 365 * -100)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if let date = dateFormatter.date(from: LocalStore.birthdate() ?? ""){
            datePicker.date = date
        }
        
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        if let gender = LocalStore.gender(){
            let row = gender == "male" ? 0:1
            genderPickerView.selectRow(row, inComponent: 0, animated: false)
        }
        
        _ = mobileNumberTextField.rx.text.map{ $0 ?? "" }.bind(to: editProfileVM.mobileNumber).disposed(by: disposeBag)
        _ = emailTextField.rx.text.map{ $0 ?? "" }.bind(to: editProfileVM.email ).disposed(by: disposeBag)
        _ = usernameTextField.rx.text.map{ $0 ?? "" }.bind(to: editProfileVM.userName ).disposed(by: disposeBag)
        _ = genderTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.editProfileVM.gender.value = text ?? ""
        }).disposed(by: disposeBag)
        _ = birthDataTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.editProfileVM.birthDate.value = text ?? ""
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(editProfileVM.userName.asObservable(), editProfileVM.birthDate.asObservable(), editProfileVM.gender.asObservable(), editProfileVM.email.asObservable(), editProfileVM.mobileNumber.asObservable()) { (userName, birthDate, gender, email, mobile) in
            
            let genderValue = (gender == self.genderPickerData.first ? "male" : "female")
            
            return (!userName.isEmpty && !birthDate.isEmpty && !gender.isEmpty && !email.isEmpty && !mobile.isEmpty) &&
                (userName != LocalStore.username() ||
                    birthDate != LocalStore.birthdate() ||
                    genderValue != LocalStore.gender() ||
                    email != LocalStore.email() ||
                    mobile != LocalStore.phoneNumber())
            
            }.bind(to: isGoodToGo).disposed(by: disposeBag)
        
        isGoodToGo.asObservable().subscribe(onNext: { [weak self] (isValid) in
            
            if isValid{
                self?.saveChangesButton.isEnabled = true
                self?.saveChangesButton.backgroundColor = UIColor.NBGoldColor()
                self?.saveChangesButton.setTitleColor(.white, for: .normal)
            }else{
                self?.saveChangesButton.isEnabled = false
                let grayColor = UIColor.init(red: 182/255, green: 180/255, blue: 182/255, alpha: 1)
                self?.saveChangesButton.backgroundColor = grayColor
                self?.saveChangesButton.setTitleColor(.black, for: .normal)
            }
            self?.saveChangesButton.roundCorners(withRadius: 6)
        }).disposed(by: disposeBag)
        
        phoneImageview.image = phoneImageview.image?.withRenderingMode(.alwaysTemplate)
        emailImageView.image = emailImageView.image?.withRenderingMode(.alwaysTemplate)
        nameImageView.image = nameImageView.image?.withRenderingMode(.alwaysTemplate)
        birthDateImageView.image = birthDateImageView.image?.withRenderingMode(.alwaysTemplate)
        genderImageView.image = genderImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func saveChangesButtonClicked(_ sender: UIButton) {
        if !editProfileVM.isValidUserName{
            showAlert(withTitle: "", andMessage: "اسم المستخدم غير صحيح")
        }
//        else if !editProfileVM.isValidGender{
//            showAlert(withTitle: "", andMessage: "اختر الجنس")
//        }else if !editProfileVM.isValidBirthDate{
//            showAlert(withTitle: "", andMessage: "تاريخ الميلاد غير صالح")
//        }
        else if !editProfileVM.isValidMobileNumber {
            showAlert(withTitle: "", andMessage: "رقم الهاتف يتكون من أرقام فقط ما بين ٧ إلى ٢٠ رقم")
        }else if !editProfileVM.isValidEmail {
            showAlert(withTitle: "", andMessage: "البريد الإلكتروني غير صالح")
            
        }else if isGoodToGo.value{
            let mobile = editProfileVM.countryCode.value + editProfileVM.mobileNumber.value
            editProfileVM.editProfile(withUsername: editProfileVM.userName.value, andGender: editProfileVM.gender.value, andMobileNumber: mobile, andEmail: editProfileVM.email.value, andBirthDate: editProfileVM.birthDate.value)
        }
    }
    
    @IBAction func datePickerDidChange(_ sender: UIDatePicker) {
        birthDataTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func pickGenderButtonClicked(_ sender: UIButton) {
        self.viewOfGenderPicker.isHidden = false
    }
    
    @IBAction func donePickingGenderClicked(_ sender: UIButton) {
        self.viewOfGenderPicker.isHidden = true
    }
    
    @IBAction func birthDateButtonClicked(_ sender: UIButton) {
        self.viewOfDatePicker.isHidden = false
    }
    
    @IBAction func donePickingBirthdateClicked(_ sender: UIButton) {
        self.viewOfDatePicker.isHidden = true
    }
    
    @IBAction func onTapDropDownCountryCode(_ sender: UIButton) {
        let presenter = HGPopUpPresenter(vc: self)
        presenter.present(.HGPopUp(withValues: CountryCode.values, AndTitle: "اختر كود الدولة"))
    }
    
}

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerData.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return genderPickerData[row]
//    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        attributedString = NSAttributedString(string: genderPickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        return attributedString
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedGender = genderPickerData[row]
        genderTextField.text = selectedGender
    }
}

extension EditProfileViewController: HGPopUpProtocol{
    func didSelectRowFromPopUp(withRow row: Int) {
        let selectedCountryCode = CountryCode.init(row: row)
        self.countryCodeLabel.text = selectedCountryCode.rawValue
    }
}

