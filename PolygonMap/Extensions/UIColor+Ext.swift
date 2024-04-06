//
//  UIColor+Ext.swift
//  PolygonMap
//
//  Created by Chingiz on 30.03.24.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor{
        let randomRed = CGFloat.random(in: 0...1)
        let randomGreen = CGFloat.random(in: 0...1)
        let randomBlue = CGFloat.random(in: 0...1)
        

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)
    }
}


