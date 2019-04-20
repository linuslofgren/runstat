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
    var displayer: WorkoutDisplayer? = nil
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
            if let distance = workout.workout.totalDistance?.doubleValue(for: HKUnit.meter()) {
                run.distance = distance
            }
            run.id = workout.uuid
            let firstLevelGranularity = 50
            for i in stride(from: 0, to: workout.positions.count, by: firstLevelGranularity)  {
                let location = Location(context: managedContext)
                let rawLocation = workout.positions[i]
                location.latitude = rawLocation.coordinate.latitude
                location.longitude = rawLocation.coordinate.longitude
                location.elevation = rawLocation.altitude
                location.time = rawLocation.timestamp
                let toNextStride = workout.positions.count - i < firstLevelGranularity ? workout.positions.count - i : firstLevelGranularity
                let secondLevelGranularity = 5
                for j in stride(from: 0, to: toNextStride, by: secondLevelGranularity) {
                    let secondLocation = SecondLayerLocation(context: managedContext)
                    let rawSecondLocation = workout.positions[i + j]
                    secondLocation.latitude = rawSecondLocation.coordinate.latitude
                    secondLocation.longitude = rawSecondLocation.coordinate.longitude
                    secondLocation.elevation = rawSecondLocation.altitude
                    secondLocation.time = rawSecondLocation.timestamp
                    let toThirdStride = toNextStride - j < secondLevelGranularity ? toNextStride - j : secondLevelGranularity
                    for k in 0..<toThirdStride {
                        let thirdLocation = ThirdLayerLocation(context: managedContext)
                        let rawThirdLocation = workout.positions[i + j + k]
                        thirdLocation.latitude = rawThirdLocation.coordinate.latitude
                        thirdLocation.longitude = rawThirdLocation.coordinate.longitude
                        thirdLocation.elevation = rawThirdLocation.altitude
                        thirdLocation.time = rawThirdLocation.timestamp
                        secondLocation.addToThirdLayerLocation(thirdLocation)
                    }
                    location.addToSecondLayerLocation(secondLocation)
                }
                run.addToLocations(location)
            }
            
            do {
                try managedContext.save()
                displayer?.display(run: run)
            } catch {
                print("Could not save")
            }
        }
    }
}

