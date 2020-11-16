//
//	Data.swift
//
//	Create by Abdorahman Mahmoud on 14/2/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct HomeData : Mappable{

	var adBook : AdBook?
	var featured : [AdBook]?
	var genres : [Genre]?
	var mostRead : [AdBook]?
    var audioBooks : [AdBook]?
    var eBooks : [AdBook]?
	var userGenres : [UserGenre]?
    var adImage: AdImage?

    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		adBook <- map["ad_book"]
		featured <- map["featured"]
		genres <- map["genres"]
		mostRead <- map["most_read"]
        audioBooks <- map["audio_books"]
        eBooks <- map["ebooks"]
		userGenres <- map["user_genres"]
		adImage <- map["ad"]
	}
}
