//
//  UpsertAddressRequestPayload.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class UpsertAddressRequestPayload: NBRequest {
    
    var address: String?
    var street: String?
    var block: String?
    var floor: String?
    var buildingNo: String?
    var countryCode: String?
    var areaId: String?
    
    init(address: String, street: String?, block: String?, floor: String?, buildingNo: String?, countryCode: String, areaId: String) {
        super.init()
        
        parameters?["address"] = address
        parameters?["street"] = street
        parameters?["block"] = block
        parameters?["floor"] = floor
        parameters?["building_no"] = buildingNo
        parameters?["country_code"] = countryCode
        parameters?["area_id"] = areaId
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        address <- map["address"]
        street <- map["street"]
        block <- map["block"]
        floor <- map["floor"]
        buildingNo <- map["building_no"]
        countryCode <- map["country_code"]
        areaId <- map["area_id"]
    }
}
