//
//  RunInfoExtractor.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-09.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import Foundation
import MapKit

typealias workoutMetric = (value: String, unit: String)

struct RunInfoStrings {
    var distance: workoutMetric
    var pace: String
    var date: String
    var splits: [(dist: String, pace: String)]
    var time: String
    var rawPace: workoutMetric
}

class RunInfoExtractor {
    
    private func calcDist(locations: [Location]) -> Double {
        var tot = 0.0
        var previous: CLLocation? = nil
        for location in locations {
            let loc1 = CLLocation(latitude: location.latitude, longitude: location.longitude)
            if previous != nil {
                tot += (previous?.distance(from: loc1))!
            }
            previous = loc1
        }
        return tot
    }
    
    private func calcSplits(locations: [Location], divider: Double, accualDistance: Double) -> [Double] {
        let projectedDist = calcDist(locations: locations)
        let mult = accualDistance / projectedDist
        print("mult: \(mult), calc: \(projectedDist), accual: \(accualDistance)")
        var splits = [Double]()
        var tot = 0.0
        var splitIndex = 1
        var previous: CLLocation? = nil
        var previousTime: Date?
        for location in locations {
            let loc1 = CLLocation(latitude: location.latitude, longitude: location.longitude)
            if previous != nil {
                tot += (previous?.distance(from: loc1))!
            }
            if previousTime == nil {
                previousTime = location.time
            }
            previous = loc1
            if (tot * mult) > Double(splitIndex) * divider {
                splits.append((location.time!.timeIntervalSince(previousTime!)))
                previousTime = location.time
                splitIndex += 1
            }
        }
        return splits
    }
    
    func from(_ run: Run) -> RunInfoStrings {
        let df1 = DateComponentsFormatter()
        df1.unitsStyle = .positional
        df1.allowedUnits = [.hour, .minute, .second]
        
        let df2 = DateComponentsFormatter()
        df2.unitsStyle = .positional
        df2.allowedUnits = [.minute, .second]
        
        let locations = run.locations?.array as! [Location]
        let dist = Measurement(value: run.distance, unit: UnitLength.meters)  //workout.totalDistance!.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo))
        let splits = calcSplits(locations: locations, divider: 1000.0, accualDistance: run.distance)
        let splitsStr = splits.map({df1.string(from: $0)!})
        var completeSplits = [(dist: String, pace: String)]()
        for (i, split) in splitsStr.enumerated() {
            // Measurement(value: i, unit: UnitLength.kilometers)
            completeSplits.append((dist: "\(i+1) km", pace: "\(split) min/km"))
        }
        print(completeSplits)
        let time = run.endDate!.timeIntervalSince(run.startDate!) //workout.duration
        let spkm = time/dist.converted(to: .kilometers).value
        print(spkm)
        let distance = String(format: "%.1f", dist.converted(to: .kilometers).value)
        let rawPace = "\(df2.string(from: spkm)!)" // min/km"
        let pace = df1.string(from: time)! + " • " + rawPace
        //        guard date != nil else {print("no date"); return}
        let df = DateFormatter()
        df.dateFormat = "dd MMM yy HH:mm"
        let date = df.string(from: run.startDate!)
        
        return RunInfoStrings(
            distance: (value: distance, unit: "km"),
            pace: pace,
            date: date,
            splits: completeSplits,
            time: df1.string(from: time)!,
            rawPace: (value: rawPace, unit: "min/km")
        )
    }
}
