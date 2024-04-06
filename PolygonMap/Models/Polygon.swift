//
//  Polygon.swift
//  PolygonMap
//
//  Created by Chingiz on 30.03.24.
//

import UIKit
import MapKit

struct Polygon: Codable, Hashable {
    var title: String
    var polygonCoordinate: String
    var annotationCoordinate: String
    var images: [Data]?
}
