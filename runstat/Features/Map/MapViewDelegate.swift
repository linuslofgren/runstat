//
//  MapViewController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-21.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import HealthKit
class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? WorkoutPolyline {
            let renderer = WorkoutRenderer(overlay: overlay)
            renderer.name = polyline.name
            renderer.date = polyline.date
            renderer.big = polyline.big
            renderer.strokeColor = polyline.color
            if polyline.big {
                renderer.lineWidth = 8
                renderer.strokeColor = UIColor(hue: 0.1, saturation: 0.7, brightness: 1.0, alpha: 1.0)
            } else {
                renderer.lineWidth = 5
                renderer.strokeColor = UIColor.random.withAlphaComponent(0.4)
            }
            return renderer
        }
        return MKOverlayRenderer()
    }


}
class WorkoutPolyline: MKPolyline {
    var big: Bool = false
    var color: UIColor = UIColor.red
    var date: Date?
    var name: String?
}

class WorkoutRenderer: MKPolylineRenderer {
    var big: Bool = false
    var name: String?
    var date: Date?
}
class DistanceAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(dist: String, coordinate: CLLocationCoordinate2D) {
        self.title = dist
        self.coordinate = coordinate
    }
}
