//
//  CountryCode.swift
//  notebook
//
//  Created by hesham ghalaab on 7/7/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

//struct CountryCode {
//    let code: String
//    let name: String
//
//    static func initSomeData() -> [CountryCode]{
//        var codes = [CountryCode]()
//        codes.append(CountryCode(code: "965", name: "KW"))
//        codes.append(CountryCode(code: "", name: ""))
//        codes.append(CountryCode(code: "", name: ""))
//        codes.append(CountryCode(code: "", name: ""))
//        codes.append(CountryCode(code: "", name: ""))
//        codes.append(CountryCode(code: "", name: ""))
//        return codes
//    }
//}

enum CountryCode: String, CaseIterable{
    case KW = "965"
    case SA = "966"
    case AE = "971"
    case QA = "974"
    case BH = "973"
    case OM = "968"
    
    init (row: Int){
        switch row {
        case 0: self = .KW
        case 1: self = .SA
        case 2: self = .AE
        case 3: self = .QA
        case 4: self = .BH
        case 5: self = .OM
        default: self = .KW
        }
    }
    
    func theValue() -> String{
        switch self{
        case .KW: return "KW"
        case .SA: return "SA"
        case .AE: return "AE"
        case .QA: return "QA"
        case .BH: return "BH"
        case .OM: return "OM"
        }
    }
    
    static var values: [String]{
        var theValues = [String]()
        CountryCode.allCases.forEach {
            let value = "\($0.theValue()) (\($0.rawValue))"
            theValues.append(value)
        }
        return theValues
        
    }
}
