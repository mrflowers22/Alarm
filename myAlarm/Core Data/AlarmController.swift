//
//  AlarmController.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CoreData

class AlarmController {
    
    //create singleton
    static let sharedInstance = AlarmController()
    
    //create data source of truth
    var alarms: [Alarm] {
        return loadFromPersistentStore()
    }
    
    //MARK: - CRUD
    func createAlarm(fireDate: Date, name: String, enabled: Bool) {
    let _ = Alarm(fireDate: fireDate, name: name, enable: enabled)
       
        //saveToPersistentStore
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate newFireDate: Date, name newName: String, enabled newEnabled: Bool){
        alarm.fireDate = newFireDate
        alarm.name = newName
        alarm.enable = newEnabled
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm){
//        guard let indexOfAlarm =  alarms.firstIndex(of: alarm) else { return }
//        alarms.remove(at: indexOfAlarm)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(alarm)
    }
    
    //MARK: - Persistence
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch  {
            print("Error saving to core data: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() -> [Alarm] {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
//           alarms = try moc.fetch(fetchRequest)
            return try moc.fetch(fetchRequest)
        } catch  {
            print("Error loading  from persistent store: \(error.localizedDescription)")
        }
        return []
    }
}
