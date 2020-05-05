//
//  HealthKitService.swift
//  app
//
//  Created by kelly on 2020/05/05.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation
import HealthKit

private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

private struct HealthUnit {
    var name: String
    var type: HKUnit
}

private struct Constants {
    static let quantityUnitMap: [HKQuantityType: HealthUnit] = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! : HealthUnit.init(name: "stepCount", type: HKUnit.count()),
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)! : HealthUnit.init(name: "activeEnergyBurned", type: HKUnit.kilocalorie()),
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)! : HealthUnit.init(name: "appleExerciseTime", type: HKUnit.minute())
    ]
}

class HealthKitService {
    static let shared = HealthKitService()
    private let store = HKHealthStore()
    
    
    private func getPermission(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let typeList: Set<HKQuantityType> = Set(Constants.quantityUnitMap.keys)
        
        self.store.requestAuthorization(toShare: [], read: typeList) {
            (success, error) in
            if success {
                print("Permission accept.")
                
                completion(true)
            } else {
                if error != nil { print(error ?? "") }
                print("Permission denied.")
                
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    private func extract(for quantityType: HKQuantityType, completion: @escaping (_ stepRetrieved: Int, _ stepAll : [[String : String]]) -> Void) {
        let startDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -7, to: Date())!)
        let mostRecentPredicate =  HKQuery.predicateForSamples(withStart:startDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: mostRecentPredicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            
            if error != nil { return }
            if let healthResult = results {
                
                var healthData : [[String:String]] = [[:]]
                var value : Int = Int()
                
                healthData.removeAll()
                
                healthResult.enumerateStatistics(from: startDate, to: Date()) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        dateFormatter.timeZone = NSTimeZone.system
                        
                        var tempDic : [String : String]?
                        let endDate : Date = statistics.endDate
                        
                        value = Int(quantity.doubleValue(for: Constants.quantityUnitMap[quantityType]!.type))
                        
                        tempDic = [
                            "enddate" : "\(dateFormatter.string(from: endDate))",
                            "value"   : "\(value)"
                        ]
                        
                        healthData.append(tempDic!)
                    }
                }
                completion(value, healthData.reversed())
            }
        }
        HKHealthStore().execute(query)
    }
    
    func getData() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        getPermission { (response) in
            guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
            guard let activeEnergyBurned = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
            guard let appleExerciseTime = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
            
            let quantityList = [stepCount, activeEnergyBurned, appleExerciseTime]
            var healthkitDataDict: [String:HealthData] = [:]
            
            quantityList.forEach { (quantityType: HKQuantityType) in
                group.enter()
                
                queue.async {
                    HealthKitService.shared.extract(for: quantityType) { (_ , healthDataList) in
                        healthDataList.forEach { (healthData: [String : String]) in
                            
                            if (healthkitDataDict[healthData["enddate"]!] == nil) {
                                healthkitDataDict[healthData["enddate"]!] = HealthData.init(enddate: healthData["enddate"]!)
                            }
                        }
                        
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: queue) {
                print(healthkitDataDict)
            }
        }
    }
}
