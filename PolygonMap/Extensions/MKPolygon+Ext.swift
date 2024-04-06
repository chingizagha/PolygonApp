//
//  MKPolygon+Ext.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit
import MapKit


extension MKPolygon {
    
    
    func toString() -> String {
        var coordinatesString = ""
        for i in 0..<self.pointCount {
            let coordinate = self.points()[i]
            coordinatesString += "\(coordinate.coordinate.latitude), \(coordinate.coordinate.longitude)\n"
        }
        return coordinatesString
    }
    
    var area: Double {
        let points = self.points()
        var area: Double = 0
        
        for i in 0..<self.pointCount {
            let point1 = points[i]
            let point2 = i == self.pointCount - 1 ? points[0] : points[i + 1]
            
            area += (point2.x + point1.x) * (point2.y - point1.y)
        }
        
        area = abs(area) / 2.0
        return area
    }
    
    
}
