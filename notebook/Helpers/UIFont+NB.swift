//
//  UIFont+NB.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/12/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import UIKit

enum Font {
    static let GulfRegular: String = "gulf"
    static let GulfBold: String = "gulf-bold"
}

enum FontSize {
    static let vTiny: CGFloat = 14.0
    static let tiny: CGFloat = 16.0
    static let small: CGFloat = 18.0
    static let medium: CGFloat = 20.0
    static let large: CGFloat = 24.0
    static let huge: CGFloat = 28.0
}

extension UIFont {
    static func GulfRegular(withSize size: CGFloat) -> UIFont {
        return UIFont.init(name: Font.GulfRegular, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func GulfBold(withSize size: CGFloat) -> UIFont {
        return UIFont.init(name: Font.GulfBold, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
