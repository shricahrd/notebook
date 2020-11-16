//
//  SignupRequestPayload.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/24/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class SignupRequestPayload: NBRequest {
    
    var fullName: String?
    var gender: String?
    var mobileNumber: String?
    var email: String?
    var birthDate: String?
    var password: String?
    var deviceId: String?
    var deviceModel: String?
    var firebaseToken: String?
    
    init(fullName: String, gender: String, mobileNumber: String, email: String, birthDate: String, password: String, deviceId: String, deviceModel: String, firebaseToken: String?) {
        super.init()
        
        parameters?["full_name"] = fullName
        parameters?["gender"] = gender
        parameters?["mobile_number"] = mobileNumber
        parameters?["email"] = email
        parameters?["birth_date"] = birthDate
        parameters?["password"] = password
        parameters?["device_id"] = deviceId
        parameters?["device_model"] = deviceModel
        parameters?["firebase_token"] = firebaseToken
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        fullName <- map["full_name"]
        gender <- map["gender"]
        mobileNumber <- map["mobile_number"]
        email <- map["email"]
        birthDate <- map["birth_date"]
        password <- map["password"]
        deviceId <- map["device_id"]
        deviceModel <- map["device_model"]
        firebaseToken <- map["firebase_token"]
    }
}
