//
//  LoginRequest.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginRequestPayload: NBRequest {
    
    var mobileNumber: String?
    var password: String?
    var deviceId: String?
    var deviceModel: String?
    var firebaseToken: String?
    
    init(mobileNumber: String, password: String, deviceId: String, deviceModel: String, firebaseToken: String?) {
        super.init()
        
        parameters?["mobile_number"] = mobileNumber
        parameters?["password"] = password
        parameters?["device_id"] = deviceId
        parameters?["device_model"] = deviceModel
        parameters?["firebase_token"] = firebaseToken
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        mobileNumber <- map["mobile_number"]
        password <- map["password"]
        deviceId <- map["device_id"]
        deviceModel <- map["device_model"]
        firebaseToken <- map["firebase_token"]
    }
}
