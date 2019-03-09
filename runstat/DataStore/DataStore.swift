//
//  DataStore.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-03.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import MapKit
import CoreData
import HealthKit

class DataStore: DataStorer, HealthDataFetcher {
    private let workoutQueue = DispatchQueue(label: "com.linuslofgren.runstat.workoutQueue")
    func get(dataHandler: @escaping (Run)->Void) {
        print("Getting...")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        workoutQueue.async {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchReq: NSFetchRequest<Run> = Run.fetchRequest()
            var workouts: [Run] = []
            do {
                workouts = try managedContext.fetch(fetchReq)
            } catch {
                print("Could not fetch")
            }
            print(workouts.count)
            for run in workouts {
                print(run.startDate?.description(with: Locale(identifier: "sv")))
                dataHandler(run)
            }
        }
        print("Before")
    }
    func save(_ workout: WorkoutData) {
        print("saving...")
        DispatchQueue.main.sync {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let run = Run(context: managedContext)
            run.startDate = workout.startDate
            run.endDate = workout.endDate
            run.id = workout.uuid
            print(workout.startDate.description(with: Locale(identifier: "sv")))
            for rawLocation in workout.positions {
                let location = Location(context: managedContext)
                location.latitude = rawLocation.coordinate.latitude
                location.longitude = rawLocation.coordinate.longitude
                location.elevation = rawLocation.altitude
                location.time = rawLocation.timestamp
                run.addToLocations(location)
            }
            
            do {
                try managedContext.save()
            } catch {
                print("Could not save")
            }
        }
    }
}

