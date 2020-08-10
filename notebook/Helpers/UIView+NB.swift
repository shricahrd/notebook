//
//  UIView+NB.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/18/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func setGradientBackground(WithStartColor: UIColor = .NBGradientStartColor(), endColor: UIColor = .NBGradientEndColor(), startLocation: Double = 0.05, endLocation: Double = 0.95, horizontalMode: Bool = false, diagonalMode: Bool = false){
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
        
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
        
        gradientLayer.colors    = [WithStartColor.cgColor, endColor.cgColor]
        
        gradientLayer.frame = bounds
        clipsToBounds = false
        layer.masksToBounds = false
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setShadow(withOpacity: Float, offset: CGSize, radius:CGFloat){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = withOpacity
        layer.shadowRadius = radius
        backgroundColor = .white
    }
    
    func roundCorners(withRadius radius: CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
