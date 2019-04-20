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
        print("OVERLAYING")
        if let polyline = overlay as? WorkoutPolyline {
            let renderer = WorkoutRenderer(overlay: overlay)
            renderer.run = polyline.run
            renderer.big = polyline.big
            renderer.strokeColor = polyline.color
            if polyline.big {
                renderer.lineWidth = 6
                renderer.strokeColor = UIColor(hue: 0, saturation: 0.8, brightness: 0.8, alpha: 1.0)
            } else {
                renderer.lineWidth = 2
                renderer.strokeColor = UIColor.random.withAlphaComponent(0.9)
            }
            print("Using workout renderer")
            return renderer
        }
        if let tileOverlay = overlay as? MKTileOverlay {
            print("Tile")
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {print("No tile")}
        print(overlay)
        return MKTileOverlayRenderer()
    }

}
class WorkoutPolyline: MKPolyline {
    var big: Bool = false
    var color: UIColor = UIColor.red
    var run: Run!
}

class WorkoutRenderer: MKPolylineRenderer {
    var big: Bool = false
    var run: Run!
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


extension UIColor {
    static var random: UIColor {
        return UIColor(hue: .random(in: 0.2...0.85), saturation: 1, brightness: 0.8, alpha: 1.0)
    }
}
