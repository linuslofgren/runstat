//
//  MapUIViewController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-21.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit
import MapKit
import HealthKit
protocol MapControllerDelegate: class {
    func tappedWorkout(run: Run)
}

protocol WorkoutDisplayer: class {
    func display(run: Run)
}

class MapViewController: UIViewController, WorkoutDisplayer {
    
    weak var delegate: MapControllerDelegate?
    weak var healthDataFetcher: HealthDataFetcher?
    
    var map: MKMapView!
    
    private var mapViewDelegate = MapViewDelegate()
    private let mappingQueue = DispatchQueue(label: "com.linuslofgren.runstat.mappingQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = MKMapView(frame: view.frame)
        map.delegate = mapViewDelegate
//        map.mapType = .hybrid
        let overlayPath = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=93bbd2660eb44b4f848a8f1ade1ece64"
        let overlay = MKTileOverlay(urlTemplate: overlayPath)
        overlay.canReplaceMapContent = true
        map.addOverlay(overlay)
        
        view.addSubview(map)
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        map.addGestureRecognizer(tapRec)
        
        print("Done in mapViewC")
    }
    
    func display(run: Run) {
        self.mappingQueue.async {
             self.showLine(run: run, color: UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5))
        }
    }
    
    var prevAnn = [DistanceAnnotation]()
    @objc func tapped(_ tap: UITapGestureRecognizer) {
        print("tapped")
        let point = tap.location(in: map)
        let coor = map.convert(point, toCoordinateFrom: map)
        let mapPoint = MKMapPoint(coor)
        for overlay in map.overlays {
            if overlay is MKPolyline {
                if let renderer = map.renderer(for: overlay) as? WorkoutRenderer {
                    let polyPoint = renderer.point(for: mapPoint)
                    guard renderer.path != nil else {
                        continue
                    }
                    if renderer.path.contains(polyPoint) {
                        delegate?.tappedWorkout(run: renderer.run)
                        showRoute(polyline: overlay as! WorkoutPolyline)
                        return
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.map.removeAnnotations(self.prevAnn)
            if let bl = self.bigLine {
                self.map.removeOverlay(bl)
            }
            self.bigLine?.big = false
            if let bl = self.bigLine {
                self.map.addOverlay(bl)
            }
        }
    }
    
    func showRoute (polyline: WorkoutPolyline) {
        self.makeBig(line: polyline)
        var annotations = [DistanceAnnotation]()
        let points = (polyline).points()
        var i = 1
        var j = 1
        var runningDist = 0.0
        var calcDist = 0.0
        let accualDist = polyline.run.distance
        var kmNr = 1
        map.removeAnnotations(prevAnn)
        while j < (polyline).pointCount {
            let point = points[j]
            let d = point.distance(to: points[j-1])
            calcDist += d
            j += 1
        }
        let mult = accualDist / calcDist
        print("mult: \(mult), calc: \(calcDist), accual: \(accualDist)")
        while i < (polyline).pointCount {
            let point = points[i]
            let d = point.distance(to: points[i-1])
            runningDist += d
            if (runningDist * mult) >= Double(kmNr * 1000) {
                annotations.append(DistanceAnnotation(dist: String(kmNr), coordinate: point.coordinate))
                kmNr += 1
            }
            i += 1
        }
        //                        print(runningDist)
        map.addAnnotations(annotations)
        prevAnn = annotations
    }
    var bigLine: WorkoutPolyline? = nil
    var locationsMap: [String: [CLLocationCoordinate2D]] = [:]
    func makeBig (line: WorkoutPolyline) {
        let polyLine = line
        polyLine.big = true
        DispatchQueue.main.async {
            self.map.removeOverlay(line)
            if let bl = self.bigLine {
                self.map.removeOverlay(bl)
            }
            
            self.bigLine?.big = false
            self.map.addOverlay(polyLine)
            if let bl = self.bigLine {
                self.map.addOverlay(bl)
            }
            self.bigLine = polyLine
        }
    }
    var dateMap: [String: Date] = [:]
//    var routes: [[CLLocationCoordinate2D]] = []
    func match(_ locations: [CLLocationCoordinate2D]) -> Bool{
//        if routes.count == 0{
//            routes.append(locations)
//            return false
//        }
        var potentialRoutes: [[CLLocationCoordinate2D]] = []
        // Check start
//        for route in routes {
//            let loc1 = CLLocation(latitude: locations[0].latitude, longitude: locations[0].latitude)
//            let loc2 = CLLocation(latitude: route[0].latitude, longitude: route[0].latitude)
//            if loc1.distance(from: loc2) < 20.0 {
//                potentialRoutes.append(route)
//            }
//        }
//        print("\(potentialRoutes.count) \(routes.count)")
        // For every point
        let acceptableError = 10.0
        for loc in locations {
            if potentialRoutes.count == 0 {
//                routes.append(locations)
                return false
            }
            for (i, route) in potentialRoutes.enumerated() {
                var smallest = acceptableError + 1
                for pos in route {
                    let loc1 = CLLocation(latitude: pos.latitude, longitude: pos.latitude)
                    let loc2 = CLLocation(latitude: loc.latitude, longitude: loc.latitude)
                    let dist = loc1.distance(from: loc2)
                    if  dist < smallest {
                        smallest = dist
                    }
                }
                if smallest > acceptableError {
                    potentialRoutes.remove(at: i)
                }
            }
        }
            // Find matching pair
        if potentialRoutes.count == 0{
//            routes.append(locations)
            return false
        } else {
            print("Found match! could be any of \(potentialRoutes.count)")
            return true
        }
//        routes.append(locations)
//        return false
    }
    var tot = 0
    func showLine(run: Run, color: UIColor) -> Void {
        guard let locations = run.locations?.array as? [Location] else {
            return
        }
        let locList = locations.map({CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)})
        let polyLine = WorkoutPolyline(coordinates: locList, count: locList.count)
        polyLine.color = color
        polyLine.run = run
        tot += locations.count
//        print(locations.count)
//        print("tot: \(tot)")
        if locList.count > 0 {

            DispatchQueue.main.async {
//                print("Adding")
                self.map.addOverlay(polyLine)
            }
        }
    }
}

