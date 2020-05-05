//
//  HealthData.swift
//  app
//
//  Created by kelly on 2020/05/05.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation

struct HealthData: Codable {
    var stepCount: Int8?
    var activeEnergyBurned: Int8?
    var appleExerciseTime: Int8?
    var enddate: String
}
