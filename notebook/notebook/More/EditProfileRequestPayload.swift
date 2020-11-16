//
//  EditProfileRequestPayload.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class EditProfileRequestPayload: NBRequest {
    
    var mobileNumber: String?
    var gender: String?
    var fullname: String?
    var email: String?
    var birthDate: String?
    
    
    init(mobileNumber: String? = nil, gender: String? = nil, fullname: String? = nil, email: String? = nil, birthDate: String? = nil) {
        super.init()
        
        if let mobileNumber = mobileNumber{
            parameters?["mobile_number"] = mobileNumber
        }
        if let gender = gender{
            parameters?["gender"] = gender
        }
        if let fullname = fullname{
            parameters?["full_name"] = fullname
        }
        if let email = email{
            parameters?["email"] = email
        }
        if let birthDate = birthDate{
            parameters?["birth_date"] = birthDate
        }
        
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        mobileNumber <- map["mobile_number"]
        gender <- map["gender"]
        fullname <- map["full_name"]
        email <- map["email"]
        birthDate <- map["birth_date"]
    }
}
