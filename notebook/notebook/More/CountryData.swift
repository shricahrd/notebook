//
//  CountryData.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/5/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
//import ObjectMapper
//
//
//struct CountryData : Mappable{
//
//    var countryCode : String?
//
//    init?(map: Map){}
//    init(){}
//
//    mutating func mapping(map: Map)
//    {
//        countryCode <- map["country_code"]
//    }
//}
struct CountryData{
    var countryCode : String
    var countryName : String
    
    static func initSomeData() -> [CountryData]{
        var countries = [CountryData]()
        
        countries.append(CountryData(countryCode: "KW", countryName: "الكويت"))
        countries.append(CountryData(countryCode: "AE", countryName: "الإمارات العربية المتحدة"))
        countries.append(CountryData(countryCode: "SA", countryName: "المملكة العربية السعودية"))
        countries.append(CountryData(countryCode: "QA", countryName: "قطر"))
        countries.append(CountryData(countryCode: "BH", countryName: "البحرين"))
        
        return countries
    }
}
