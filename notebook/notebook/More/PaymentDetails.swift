//
//  PaymentDetails.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/8/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct PaymentDetails : Mappable{
    
    var invoiceId : Int?
    var paymentUrl : String?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        invoiceId <- map["invoice_id"]
        paymentUrl <- map["payment_url"]
    }
}
