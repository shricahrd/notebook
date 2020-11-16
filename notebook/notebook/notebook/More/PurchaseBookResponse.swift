//
//  PurchaseBookResponse.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/8/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct PurchaseBookResponse : Mappable{
    
    var meta : RootMeta?
    var data: PaymentDetails?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        meta <- map["meta"]
        data <- map["data"]
    }
}
