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
    var startDate: Date
    var endDate: Date
    var workout: HKWorkout
    var uuid: UUID
}

protocol HealthDataFetcher: class {
    func get(dataHandler: @escaping (Run)->Void)
//    func addDataFor(workout: HKWorkout, with id: String, location: [CLLocation?], done: Bool) -> Void
}

class HealthController {
    var dataStore: DataStorer?
    let healthStore = HKHealthStore()
    var localLocations: [String:[CLLocation]] = [:]
    func beginHealthFetch() {
        func locationsForLaps(laps: [HKSample]?, saveData: @escaping ([CLLocation]?, HKSample, UUID) -> Void) {
            for lap in laps! {
                let routeQuery = HKWorkoutRouteQuery(route: lap as! HKWorkoutRoute) { (query, locationsOrNil, done, errorOrNil) in
                    if let locations = locationsOrNil {
                        if self.localLocations[lap.uuid.uuidString] == nil {
                            self.localLocations[lap.uuid.uuidString] = []
                        }
                        self.localLocations[lap.uuid.uuidString]! += locations
                    }
                    if done {
                        saveData(self.localLocations[lap.uuid.uuidString], lap, lap.uuid)
                    }
                }
                healthStore.execute(routeQuery)
            }
        }
        func routesForWorkouts(workouts: [HKSample]?) {
            let workoutsDispachGroup = DispatchGroup()
            for workout in workouts! {
                workoutsDispachGroup.enter()
                let thisWorkout = HKQuery.predicateForObjects(from: workout as! HKWorkout)
                let lapsQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: thisWorkout, anchor: nil, limit: HKObjectQueryNoLimit) { (query, laps, deletedObjects, newAnchor, error) in
                    locationsForLaps(laps: laps) { (locations, sample, id) in
                        let workoutData = WorkoutData(positions: locations ?? [], startDate: workout.startDate, endDate: workout.endDate, workout: workout as! HKWorkout, uuid: id)
                        self.dataStore?.save(workoutData)
                    }
                }
                healthStore.execute(lapsQuery)
            }
        }
        
        var anchor = HKQueryAnchor.init(fromValue: 0)
        
        if UserDefaults.standard.object(forKey: "myAnch") != nil {
            do {
                let data = UserDefaults.standard.object(forKey: "myAnch") as! Data
                anchor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! HKQueryAnchor
            } catch {
                print(error)
            }
            
        }
        
        let query = HKAnchoredObjectQuery(type: HKWorkoutType.workoutType(), predicate: nil, anchor: anchor, limit: HKObjectQueryNoLimit) { (query, laps, deletedObjects, newAnchor, error) in
            print("Query began")
            do {
               let anchorData: Data = try NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)
                UserDefaults.standard.set(anchorData, forKey: "myAnch")
            } catch {
                print(error)
            }
            routesForWorkouts(workouts: laps)
        }
        query.updateHandler = { (query, laps, deletedObjects, newAnchor, error) in
            do {
                let anchorData: Data = try NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)
                UserDefaults.standard.set(anchorData, forKey: "myAnch")
            } catch {
                print(error)
            }
            routesForWorkouts(workouts: laps)
        }
        healthStore.execute(query)
    }
    
    func requestAuth(cb: @escaping (Bool) -> Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            print("no health")
            cb(false)
            return
        }
        let types = Set([HKObjectType.workoutType(), HKSeriesType.workoutRoute()])
        
        healthStore.requestAuthorization(toShare: nil, read: types) { (success, error) in
            cb(success)
        }
    }
}
