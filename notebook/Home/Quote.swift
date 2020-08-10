//
//	Quote.swift
//
//	Create by Abdorahman Mahmoud on 14/2/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct Quote : Mappable{

	var body : String?
	var bookId : Int?
	var id : Int?


    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		body <- map["body"]
		bookId <- map["book_id"]
		id <- map["id"]
		
	}

}
