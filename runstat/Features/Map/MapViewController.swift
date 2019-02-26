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
    func tappedWorkout(workout: HKWorkout, date: Date?, name: String?)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = MKMapView(frame: view.frame)
        map.delegate = mapViewDelegate
        map.mapType = .hybrid
        view.addSubview(map)
        healthDataFetcher?.beginHealthFetch() {
            (id, date, locations, workout) in
                self.saveLocation(id: id, date: date, locations: locations as! [CLLocation])
//            self.showLine(id: id, distance: workout.totalDistance!, color: UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5), time: workout.duration)
                        self.showLine(id: id, workout: workout, color: UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5))

        }
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        map.addGestureRecognizer(tapRec)
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
                        
                        //                        print(renderer.data
                       // self.showInfo(text: renderer.data, time: renderer.time)
                        delegate?.tappedWorkout(workout: renderer.workout, date: renderer.date, name: renderer.name)
                        self.makeBig(line: overlay as! WorkoutPolyline)
                        var annotations = [DistanceAnnotation]()
                        let points = (overlay as! WorkoutPolyline).points()
                        var i = 1
                        var runningDist = 0.0
                        var kmNr = 1
                        map.removeAnnotations(prevAnn)
                        while i < (overlay as! WorkoutPolyline).pointCount {
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
        //self.showInfo(text: 0, time: 0)
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
    func saveLocation(id: String, date: Date, locations: [CLLocation]) -> Void {
        if locationsMap[id] == nil {
            locationsMap[id] = locations.map({$0.coordinate})
        } else {
            locationsMap[id]! += locations.map({$0.coordinate})
        }
        dateMap[id] = date
    }
    
    func showLine(id: String, workout: HKWorkout, color: UIColor) -> Void {
        let locList = locationsMap[id]
        guard locList != nil else {
            return
        }
        let polyLine = WorkoutPolyline(coordinates: locList!, count: locList!.count)
        polyLine.color = color
        polyLine.workout = workout
        let geoCode = CLGeocoder()
        if locList != nil && locList?.count ?? -1 > 0{
            geoCode.reverseGeocodeLocation(CLLocation(latitude: locList![0].latitude, longitude: locList![0].longitude), completionHandler: {
                (placemarks, error) in
                guard let placemark = placemarks?.first else {return}
                polyLine.name = (placemark.locality ?? "") + " - " + (placemark.thoroughfare ?? "")
                print(polyLine.name)
                polyLine.date = self.dateMap[id]
                DispatchQueue.main.async {
                    self.map.addOverlay(polyLine)
                }
                
            })
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
