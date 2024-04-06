//
//  MKMapView+Ext.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit
import MapKit

extension MKMapView{
    
    func removeAllOverlays() {
            // Remove all overlays
            let overlaysToRemove = self.overlays
            self.removeOverlays(overlaysToRemove)
        }

    func removeAllAnnotations() {
        // Remove all annotations
        let annotationsToRemove = self.annotations
        self.removeAnnotations(annotationsToRemove)
    }
}

