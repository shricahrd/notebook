//
//  DeviceInfoRequestPayload.swift
//  notebook
//
//  Created by Abdorahman Youssef on 5/15/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class DeviceInfoRequestPayload: NBRequest {
    
    var deviceId: String?
    var deviceModel: String?
    var firebaseToken: String?
    
    init(deviceId: String, deviceModel: String, firebaseToken: String?) {
        super.init()
        
        parameters?["device_id"] = deviceId
        parameters?["device_model"] = deviceModel
        parameters?["firebase_token"] = firebaseToken
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        deviceId <- map["device_id"]
        deviceModel <- map["device_model"]
        firebaseToken <- map["firebase_token"]
    }
}
