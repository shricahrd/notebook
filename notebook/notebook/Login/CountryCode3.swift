//
//  CountryCode3.swift
//  notebook
//
//  Created by Lenin Niclavos on 22/03/20.
//  Copyright © 2020 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper



struct CountriesData : Mappable {
    var country_code : String?
    var country_name : String?
    var country_name_en : String?
    var country_phone : String?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map) {
        
        country_code <- map["country_code"]
        country_name <- map["country_name"]
        country_name_en <- map["country_name_en"]
        country_phone <- map["country_phone"]
    }
    
}
