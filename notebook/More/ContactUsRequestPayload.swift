//
//  ContactUsRequestPayload.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactUsRequestPayload: NBRequest {
    
    var mobileNumber: String?
    var message: String?
    var userId: String?
    
    init(mobileNumber: String, message: String, userId: String) {
        super.init()
        
        parameters?["mobile_number"] = mobileNumber
        parameters?["message"] = message
        parameters?["user_id"] = userId
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        mobileNumber <- map["mobile_number"]
        message <- map["message"]
        userId <- map["user_id"]
    }
}
