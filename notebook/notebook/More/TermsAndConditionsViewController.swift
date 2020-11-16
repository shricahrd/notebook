//
//  TermsAndConditionsViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: NBParentViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTermsAndConditions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "الشروط والأحكام"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addPlayButton()
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        termsAndConditionsTextView.font = UIFont.GulfBold(withSize: FontSize.vTiny)
    }
    
    func setupTermsAndConditions(){
        if let path = Bundle.main.path(forResource: "TC", ofType: "html") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                let attribute = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
                attribute.addAttribute(.backgroundColor, value: UIColor.clear, range:  NSRange(location: 0, length: attribute.length))
                attribute.addAttribute(.foregroundColor, value: UIColor.white, range:  NSRange(location: 0, length: attribute.length))
                
                termsAndConditionsTextView.attributedText = attribute
                
            } catch {
                print("unexpected error while fetching Terms and conditions file")
            }
        }
    }
}
