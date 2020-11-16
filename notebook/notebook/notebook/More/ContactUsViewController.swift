//
//  ContactUsViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/28/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContactUsViewController: NBParentViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var mobileNumberTitleLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var contactUsVM: ContactUsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactUsVM = ContactUsViewModel(viewController: self)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "تواصل معنا"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addPlayButton()
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        messageTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        sendMessageButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        messageTextView.font = UIFont.GulfRegular(withSize: FontSize.vTiny)
        mobileNumberTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        mobileNumberTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        headerLabel.font =  UIFont.GulfBold(withSize: FontSize.vTiny)
        //sendMessageButton.setGradientBackground(horizontalMode: true)
        sendMessageButton.roundCorners(withRadius: 6)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        _ = mobileNumberTextField.rx.text.map{ $0 ?? "" }.bind(to: contactUsVM.mobileNumber ).disposed(by: disposeBag)
        _ = messageTextView.rx.text.map{ $0 ?? "" }.bind(to: contactUsVM.message ).disposed(by: disposeBag)
    }

    @IBAction func sendMessageButtonClicked(_ sender: UIButton) {
        if !contactUsVM.isValidMobileNumber {
            showAlert(withTitle: "", andMessage: "رقم الهاتف او البريد يتكون من ٧ إلى ١٠٠ حرف أو رقم")
        }else if !contactUsVM.isValidMessage{
            showAlert(withTitle: "", andMessage: "عفوا، قم بكتابة رسالة")
        }else{
            contactUsVM.contactUs(withMobileNumber: mobileNumberTextField.text ?? "", andMessage: messageTextView.text)
        }
    }
    
    func successHandler(){
        showAlert(withTitle: "", andMessage: "تم إرسال رسالتك بنجاح") { (action) in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
