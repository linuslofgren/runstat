//
//  DataStore.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-03.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import Foundation

protocol DataStorer {
    func save(_: WorkoutData) -> Void
}
