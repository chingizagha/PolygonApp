//
//  String+Ext.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit
import MapKit

extension String{
    
    static func fromStringAnnotation(_ string: String) -> CLLocationCoordinate2D {
        let components = string.components(separatedBy: ",")
        guard components.count == 2,
              let latitude = Double(components[0]),
              let longitude = Double(components[1]) else {
            return CLLocationCoordinate2D(latitude: 2, longitude: 2)
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func fromStringMKPolygon(coordinatesString: String) -> MKPolygon {
        let coordinatesArray = coordinatesString.split(separator: "\n").map { coordinateString -> CLLocationCoordinate2D in
            let components = coordinateString.split(separator: ",").map { str in
                str.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            guard components.count == 2,
                  let latitude = Double(components[0]),
                  let longitude = Double(components[1]) else {
                fatalError("Invalid coordinate string format: \(coordinateString)")
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        let polygon = MKPolygon(coordinates: coordinatesArray, count: coordinatesArray.count)
        return polygon
    }
}
