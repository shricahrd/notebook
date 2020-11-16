//
//  UpsertUserAddressResponse.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct UpsertUserAddressResponse : Mappable{
    
    var meta : RootMeta?
    var data: AddressData?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        meta <- map["meta"]
        do{
            let address = map["data"]
            if let jsonData = address.currentValue{
                let jsonAddress = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                data = try JSONDecoder().decode(AddressData.self, from: jsonAddress)
            }
        } catch{
            print(error)
        }
    }
}
