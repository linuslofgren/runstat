//
//  Coordinator.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-24.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit
import HealthKit
class Coordinator: UIViewController, InfoCardControllerDelegate, MapControllerDelegate {
    
    lazy var infoCardViewController: InfoCardViewController = {
        let controller = InfoCardViewController()
        controller.delegate = self
        return controller
    }()
    
    lazy var healthFetcher: HealthController = {
        let fetcher = HealthController()
        return fetcher
    }()
    
    lazy var mapViewController: MapViewController = {
        let controller = MapViewController(healthDataFetcher: healthFetcher)
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        add(mapViewController)
        add(infoCardViewController)
    }
    
    func tappedWorkout(workout: HKWorkout, date: Date?, name: String?) {
        infoCardViewController.showInfoFor(workout: workout, date: date, name: name)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
