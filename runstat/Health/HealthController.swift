//
//  HealthController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-21.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import Foundation
import HealthKit
import MapKit

struct WorkoutData {
    var positions: [CLLocation]
    var date: Date
    var duration: TimeInterval
}

protocol HealthDataFetcher: class {
    func beginHealthFetch(dataHandler: @escaping (String, Date, [CLLocation?], HKWorkout)->Void)
//    func addDataFor(workout: HKWorkout, with id: String, location: [CLLocation?], done: Bool) -> Void
}

class HealthController: HealthDataFetcher {
    
    func beginHealthFetch(dataHandler: @escaping (String, Date, [CLLocation?], HKWorkout)->Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            print("no health")
            return
        }
        let healthStore = HKHealthStore()
        var localLocations: [String:[CLLocation]] = [:]
        let routesDispatchGroup = DispatchGroup()
        func locationsForLaps(laps: [HKSample]?, cb: @escaping ([CLLocation]?, HKSample) -> Void) {
            routesDispatchGroup.enter()
            let lapsDispatchGroup = DispatchGroup()
            for lap in laps! {
                lapsDispatchGroup.enter()
                let routeQuery = HKWorkoutRouteQuery(route: lap as! HKWorkoutRoute) { (query, locationsOrNill, done, errorOrNil) in
                    if done {
                        lapsDispatchGroup.leave()
                        cb(localLocations[lap.uuid.uuidString], lap)
                    }
                    guard locationsOrNill != nil else { return }
                    if localLocations[lap.uuid.uuidString] == nil {
                        localLocations[lap.uuid.uuidString] = locationsOrNill!
                    } else {
                        localLocations[lap.uuid.uuidString]! += locationsOrNill!
                    }
                
                }
                healthStore.execute(routeQuery)
            }
            lapsDispatchGroup.notify(queue: DispatchQueue.main) {
                print("One workout done")
                routesDispatchGroup.leave()
            }
        }
        func routesForWorkouts(workouts: [HKSample]?, cb: @escaping () -> Void) {
            let workoutsDispachGroup = DispatchGroup()
            for workout in workouts! {
                workoutsDispachGroup.enter()
                let thisWorkout = HKQuery.predicateForObjects(from: workout as! HKWorkout)
                let lapsQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: thisWorkout, anchor: nil, limit: HKObjectQueryNoLimit) { (query, laps, deletedObjects, newAnchor, error) in
                    locationsForLaps(laps: laps) { (locations, sample) in
                        dataHandler(sample.uuid.uuidString, sample.endDate, locations ?? [], workout as! HKWorkout)
                    }
                    routesDispatchGroup.notify(queue: DispatchQueue.main) {
                        print("Bach of workouts done")
                        workoutsDispachGroup.leave()
                    }
                }
                healthStore.execute(lapsQuery)
            }
            workoutsDispachGroup.notify(queue: DispatchQueue.main) {
                print("Should have run all")
            }
        }
        
        let query = HKAnchoredObjectQuery(type: HKWorkoutType.workoutType(), predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (query, laps, deletedObjects, newAnchor, error) in
            routesForWorkouts(workouts: laps) {
                
            }
        }
        
        let types = Set([HKObjectType.workoutType(), HKSeriesType.workoutRoute()])
        
        healthStore.requestAuthorization(toShare: nil, read: types) { (success, error) in
            print(success)
            print("health")
            healthStore.execute(query)
        }
    }
}
