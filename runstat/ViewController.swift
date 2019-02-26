////
////  ViewController.swift
////  runstat
////
////  Created by Linus Löfgren on 2019-02-03.
////  Copyright © 2019 Linus Löfgren. All rights reserved.
////
//
//import UIKit
//import HealthKit
//import CoreLocation
//import MapKit
//
//private enum State {
//    case closed
//    case open
//}
//extension State {
//    var otherDir: State {
//        switch self {
//        case .open:
//            return .closed
//        case .closed:
//            return .open
//        }
//    }
//}
//
//class ViewController: UIViewController {
//    @IBOutlet weak var mapView: MKMapView!
//    let mapDelegate = MapViewDelegate()
//    lazy var boxView: InfoCardView = {
//        let box = InfoCardView()
//        return box
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("start")
//        mapView.delegate = mapDelegate
//        layout()
////        let rec = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
////        boxView.addGestureRecognizer(rec)
//        boxView.addGestureRecognizer(boxTapRec)
//        boxView.addGestureRecognizer(boxPanRec)
//        boxView.distText =  String(format: "%.1f km in %.1f minutes @ %.0f:%02.0f min/km", 0, 0, 0, 0)
//        boxView.timeText = String(format: "%.1f km in %.1f minutes @ %.0f:%02.0f min/km", 0, 0, 0, 0)
//        // Do any additional setup after loading the view, typically from a nib.
//        let healthController = HealthController()
//        healthController.beginHealthFetch() {
//            (id, date, locationsOrNil, workout, done) in
//            if !done {
//                self.saveLocation(id: id, locations: locationsOrNil as! [CLLocation])
//                return
//            }
//            self.showLine(id: id, distance: workout.totalDistance!, color: UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5), time: workout.duration)
//        }
//        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
//        mapView.addGestureRecognizer(tapRec)
//    }
//    var prevAnn = [DistanceAnnotation]()
//    @objc func tapped(_ tap: UITapGestureRecognizer) {
//        print("tapped")
//        let point = tap.location(in: mapView)
//        let coor = mapView.convert(point, toCoordinateFrom: mapView)
//        let mapPoint = MKMapPoint(coor)
//        for overlay in mapView.overlays {
//            if overlay is MKPolyline {
//                if let renderer = mapView.renderer(for: overlay) as? WorkoutRenderer {
//                    let polyPoint = renderer.point(for: mapPoint)
//                    if renderer.path.contains(polyPoint) {
//
////                        print(renderer.data
//                        // self.showInfo(text: renderer.data, time: renderer.time)
//                        self.makeBig(line: overlay as! WorkoutPolyline)
//                        var annotations = [DistanceAnnotation]()
//                        let points = (overlay as! WorkoutPolyline).points()
//                        var i = 1
//                        var runningDist = 0.0
//                        var kmNr = 1
//                        mapView.removeAnnotations(prevAnn)
//                        while i < (overlay as! WorkoutPolyline).pointCount {
//                            let point = points[i]
//                            let d = point.distance(to: points[i-1])
//                            runningDist += d
//                            if runningDist >= Double(kmNr * 1000) {
//                                annotations.append(DistanceAnnotation(dist: String(kmNr), coordinate: point.coordinate))
//                                kmNr += 1
//                            }
//                            i += 1
//                        }
////                        print(runningDist)
//                        mapView.addAnnotations(annotations)
//                        prevAnn = annotations
//                        return
//                    }
//                }
//            }
//        }
//        if currentState == .open {
//            boxViewTapped(recognizer: tap)
//        }
//        DispatchQueue.main.async {
//            self.mapView.removeAnnotations(self.prevAnn)
//            if let bl = self.bigLine {
//                self.mapView.removeOverlay(bl)
//            }
//
//            self.bigLine?.big = false
//            if let bl = self.bigLine {
//                self.mapView.addOverlay(bl)
//            }
//        }
//        self.showInfo(text: 0, time: 0)
//    }
//    var bigLine: WorkoutPolyline? = nil
//    var locationsMap: [String: [CLLocationCoordinate2D]] = [:]
//    func makeBig (line: WorkoutPolyline) {
//        let polyLine = line
//        polyLine.big = true
//        DispatchQueue.main.async {
//            self.mapView.removeOverlay(line)
//            if let bl = self.bigLine {
//                self.mapView.removeOverlay(bl)
//            }
//
//            self.bigLine?.big = false
//            self.mapView.addOverlay(polyLine)
//            if let bl = self.bigLine {
//                self.mapView.addOverlay(bl)
//            }
//            self.bigLine = polyLine
//        }
//    }
//    func showInfo(text: Double, time: Double) {
//        let spkm = time/text
//        self.boxView.distText = String(format: "%.1f km in %.1f minutes @ %.0f:%02.0f min/km", text, time/60, floor(spkm/60), ((spkm/60)-floor(spkm/60))*60)
//    }
//
//    func saveLocation(id: String, locations: [CLLocation]) -> Void {
//        guard locationsMap[id] != nil else {
//            locationsMap[id] = locations.map({$0.coordinate})
//            return
//        }
//        locationsMap[id]! += locations.map({$0.coordinate})
//    }
//
//    func showLine(id: String, distance: HKQuantity, color: UIColor, time: TimeInterval) -> Void {
//        let locList = locationsMap[id]
//        guard locList != nil else {
//            return
//        }
//        let polyLine = WorkoutPolyline(coordinates: locList!, count: locList!.count)
////        polyLine.data = distance.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo))
////        polyLine.time = time
//        polyLine.color = color
//        DispatchQueue.main.async {
//            self.mapView.addOverlay(polyLine)
//        }
//
//    }
//    let bottomConstant: CGFloat = 400
//    var bottomConstraint = NSLayoutConstraint()
//    func layout() {
//        boxView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(boxView)
//        boxView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        boxView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        bottomConstraint = boxView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant)
//        bottomConstraint.isActive = true
//        boxView.heightAnchor.constraint(equalToConstant: 500).isActive = true
//        boxView.setNeedsLayout()
//    }
//    private var animationProg: CGFloat = 0
//    private var currentState: State = .closed
//
//    lazy var boxTapRec: UITapGestureRecognizer = {
//        let rec = UITapGestureRecognizer()
//        rec.addTarget(self, action: #selector(boxViewTapped(recognizer:)))
//        return rec
//    }()
//    lazy var boxPanRec: UIPanGestureRecognizer = {
//        let rec = UIPanGestureRecognizer()
//        rec.addTarget(self, action: #selector(boxViewPanned(recognizer:)))
//        return rec
//    }()
//    var transitionAnimator: UIViewPropertyAnimator!
//    private func animateTransitionIfNeeded(to: State, duration: Double) {
//        let state = to
//        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
//            switch state {
//            case .open:
//                self.bottomConstraint.constant = 0
//                self.boxView.layer.cornerRadius = 20
//            case .closed:
//                self.bottomConstraint.constant = self.bottomConstant
//                self.boxView.layer.cornerRadius = 0
//            }
//            self.view.layoutIfNeeded()
//        })
//        transitionAnimator.addCompletion {
//            (position) in
//            switch position {
//            case .start:
//                self.currentState = state.otherDir
//            case .end:
//                self.currentState = state
//            case .current:
//                ()
//            }
//            switch self.currentState {
//            case .open:
//                self.bottomConstraint.constant = 0
//                self.boxView.layer.cornerRadius = 20
//            case .closed:
//                self.bottomConstraint.constant = self.bottomConstant
//                self.boxView.layer.cornerRadius = 0
//            }
//        }
//        transitionAnimator.startAnimation()
//    }
//    @objc func boxViewTapped(recognizer: UITapGestureRecognizer) {
//        let state = currentState.otherDir
//        animateTransitionIfNeeded(to: state, duration: 0.8)
//    }
//
//    var animator: UIViewPropertyAnimator!
//    @objc func boxViewPanned(recognizer: UIPanGestureRecognizer) {
//        switch recognizer.state {
//        case .began:
//            animateTransitionIfNeeded(to: currentState.otherDir, duration: 0.8)
//            transitionAnimator.pauseAnimation()
//            animationProg = transitionAnimator.fractionComplete
//        case .changed:
//            let translation = recognizer.translation(in: boxView)
//            var frac = -translation.y / bottomConstant
//            if currentState == .open { frac *= -1 }
//            transitionAnimator.fractionComplete = frac + animationProg
//        case .ended:
//            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//        default:
//            ()
//        }
//    }
//}
//extension UIColor {
//    static var random: UIColor {
//        return UIColor(red: .random(in: 0.5...1),
//                       green: .random(in: 0.5...1),
//                       blue: .random(in: 0.5...1),
//                       alpha: 1.0)
//    }
//}
