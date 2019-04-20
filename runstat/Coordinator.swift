//
//  Coordinator.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-24.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit
import HealthKit
import CoreData
import MapKit

class Coordinator: UIViewController, InfoCardControllerDelegate, MapControllerDelegate {
    
    lazy var infoCardViewController: InfoCardViewController = {
        let controller = InfoCardViewController()
        controller.delegate = self
        return controller
    }()
    
    lazy var healthFetcher: HealthController = {
        let fetcher = HealthController()
        fetcher.dataStore = dataStore
        return fetcher
    }()
    
    lazy var mapViewController: MapViewController = {
        let controller = MapViewController()
        controller.delegate = self
        return controller
    }()
    
    lazy var dataStore: DataStore = {
        let store = DataStore()
        store.displayer = mapViewController
        return store
    }()
    
    override func viewDidLoad() {
        healthFetcher.requestAuth() {
            (success) in
            guard success else {return}
            DispatchQueue.main.sync {
                self.add(self.mapViewController)
                self.add(self.infoCardViewController)
                self.healthFetcher.beginHealthFetch()
                self.dataStore.get() {
                    (run) in
                    self.mapViewController.display(run: run)
                }
            }
        }
    }
    
    func tappedWorkout(run: Run) {
        infoCardViewController.showInfoFor(run: run)
    }
}

extension UIViewController {
    func add(_ child: UIViewController, customView: UIView? = nil) {
        addChild(child)
        if let v = customView {
            v.addSubview(child.view)
        } else {
            view.addSubview(child.view)
        }
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
