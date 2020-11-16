//
//  AddressResponse.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/5/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct AddressData : Codable{
    
    var address : String?
    var area_id : String?
    var area_name : AreaData?
    var block : String?
    var building_no : String?
    var country_code : String?
    var floor : String?
    var id : Int?
    var street : String?
    var user_id: String?
    var country_name: String?
}
