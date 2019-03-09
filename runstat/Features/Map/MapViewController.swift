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
    func tappedWorkout(workout: HKWorkout?, date: Date?, name: String?)
}

class MapViewController: UIViewController {
    
    weak var delegate: MapControllerDelegate?
    weak var healthDataFetcher: HealthDataFetcher?
    
    var map: MKMapView!
    
    convenience init(healthDataFetcher: HealthDataFetcher) {
        self.init(nibName: nil, bundle: nil)
        self.healthDataFetcher = healthDataFetcher
    }
    
    private var mapViewDelegate = MapViewDelegate()
    private let mappingQueue = DispatchQueue(label: "com.linuslofgren.runstat.mappingQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = MKMapView(frame: view.frame)
        map.delegate = mapViewDelegate
        map.mapType = .hybrid
        view.addSubview(map)
        healthDataFetcher?.get() {
            (run) in
            self.mappingQueue.async {
    //            self.showLine(id: id, distance: workout.totalDistance!, color: UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5), time: workout.duration)
                 self.showLine(id: run.id?.uuidString ?? "", locations: run.locations?.array as! [Location], color: UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5))
            }

        }
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        map.addGestureRecognizer(tapRec)
        print("Done in mapViewC")
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
                    if renderer.path.contains(polyPoint) {
                        delegate?.tappedWorkout(workout: nil, date: renderer.date, name: renderer.name)
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
        var runningDist = 0.0
        var kmNr = 1
        map.removeAnnotations(prevAnn)
        while i < (polyline).pointCount {
            let point = points[i]
            let d = point.distance(to: points[i-1])
            runningDist += d
            if runningDist >= Double(kmNr * 1000) {
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
    
    func showLine(id: String, locations: [Location], color: UIColor) -> Void {
        let locList = locations.map({CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)})
        let polyLine = WorkoutPolyline(coordinates: locList, count: locList.count)
        polyLine.color = color
        if locList.count > 0 {
            polyLine.name = "Best run"
            polyLine.date = self.dateMap[id]
            DispatchQueue.main.async {
                self.map.addOverlay(polyLine)
            }
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0.5...1),
                       green: .random(in: 0.5...1),
                       blue: .random(in: 0.5...1),
                       alpha: 1.0)
    }
}
