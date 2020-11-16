//
//  String+NB.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    func isNumber() -> Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isvalidMobileNumber() -> Bool {
        let maximumPhonenumber = 20
        let minmumPhonenumber = 7
        if isNumber() == false || count < minmumPhonenumber || count > maximumPhonenumber {
            return false
        } else {
            return true
        }
    }
    
    func isvalidPassword() -> Bool {
        let minmumPhonenumber = 6
        if count < minmumPhonenumber {
            return false
        } else {
            return true
        }
    }
    
    func cleanFloatNumber() -> String {
        if isEmpty == false {
            let float = NSString(string: self).doubleValue
            return float.remainder(dividingBy: 1) == 0 ? String(format: "%.0f", float) : String(format: "%.2f", float)
        } else {
            return ""
        }
    }
    
    func isValidEmail() -> Bool {
        let validEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validEmailPredicate = NSPredicate(format: "SELF MATCHES %@", validEmailRegex)
        
        return validEmailPredicate.evaluate(with: self)
    }
    
    var imageFromBase64EncodedString: UIImage? {
        if let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
