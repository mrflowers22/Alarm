//
//  AlarmController.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

class AlarmController {
    
    //create singleton
    static let sharedInstance = AlarmController()
    
    //create data source of truth
    var alarms: [Alarm] = []
    
    //MARK: - CRUD
    func createAlarm(fireDate: Date, name: String, enabled: Bool) {
        
    }
    
    //MARK: - Persistence
}
