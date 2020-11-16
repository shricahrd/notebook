//
//  Connectivity.swift
//  notebook
//
//  Created by hesham ghalaab on 7/18/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
