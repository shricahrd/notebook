//
//  BookGiftViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/12/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift

class BookGiftViewController: NBParentViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var enterCodeTextLabel: UILabel!
    @IBOutlet weak var getTheBookButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let disposeBag = DisposeBag()
    var bookGiftVM: BookGiftViewModel!
    weak var bookDetailsDelegate: BookDetailsDelegate?
    var bookId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookGiftVM = BookGiftViewModel.init(viewController: self)
        setupView()
    }

    
    func setupView(){
        containerView.roundCorners(withRadius: 6)
        getTheBookButton.roundCorners(withRadius: 6)
        getTheBookButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        enterCodeTextLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        noteTextLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        codeTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        let attribute = NSAttributedString(string: "الكود",
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        codeTextField.attributedPlaceholder = attribute
        _ = codeTextField.rx.text.map{ $0 ?? "" }.bind(to: bookGiftVM.code ).disposed(by: disposeBag)
    }
        
    @IBAction func getTheBookButtonClicked(_ sender: UIButton) {
        if !bookGiftVM.isValidCode {
            showAlert(withTitle: "", andMessage: "برجاء إدخال الكود")
        }else{
            guard let bookId = bookId else {
                showAlert(withTitle: "", andMessage: "حدث خطأ غير متوقع")
                return
            }
            bookGiftVM.purchaseBook(withOrderType: OrderType.coupon.rawValue, andCoupon: bookGiftVM.code.value, andBookId: bookId)
        }
    }
    
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
