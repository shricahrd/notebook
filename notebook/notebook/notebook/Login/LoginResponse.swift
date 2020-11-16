//
//	RootClass.swift
//
//	Create by Abdorahman Mahmoud on 6/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct LoginResponse :  Mappable{

	var data : LoginData?
	var meta : RootMeta?

    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		data <- map["data"]
		meta <- map["meta"]
	}

}
