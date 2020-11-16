//
//  BookTracks.swift
//  notebook
//
//  Created by Satya on 16/09/20.
//  Copyright © 2020 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

struct BookTrack : Mappable{

    var id : Int?
    var trackFile : String?
    var trackName : String?
    var trackNo : Int?

    init?(map: Map){}
    init(){}

    mutating func mapping(map: Map)
    {
        id <- map["id"]
        trackFile <- map["track_file"]
        trackName <- map["track_name"]
        trackNo <- map["track_no"]
    }
}

/**
 tracks =             (
                     {
         id = 19;
         "track_file" = "https://notebooklib.com/admin2/public/books/142/\U0641\U0648\U0628\U064a\U0627-1575434309.m4b";
         "track_name" = "\U0633\U064a\U0627\U0631\U0629 \U0623\U062c\U0631\U0629";
         "track_no" = 1;
     },
                     {
         id = 20;
         "track_file" = "https://notebooklib.com/admin2/public/books/142/\U0641\U0648\U0628\U064a\U0627-1575434309.m4b";
         "track_name" = "\U0645\U0631\U0627\U0647\U0642\U0629";
         "track_no" = 2;
     }
 )
 */
