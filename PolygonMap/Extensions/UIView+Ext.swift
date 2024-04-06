//
//  UIView+Ext.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit

extension UIView{
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
