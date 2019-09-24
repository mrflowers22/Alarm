//
//  AlarmController.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    //create default implementations for the two protocol functions
    func scheduleUserNotifications(for alarm: Alarm) {
        //create an instance of UNMutableNotificationContent: The editable content for a notification
        let content = UNMutableNotificationContent()
        content.title = "Notification brotha"
        content.body = "Can you semll what the rock is cooking?"
        content.sound = .default()
        
        //create date components using the fireDate of your alarm
        guard let fireDate = alarm.fireDate, let alarmUUID = alarm.uuid else { return }
        let  dateComponents = Calendar.current.dateComponents([.minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //Now that you have the unMutableNotificationContent & UNCalendarNotificationTrigger you can initialize UNNotificationRequest
        let request = UNNotificationRequest(identifier: alarmUUID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error adding notification request: \(error)")
            }
            print("notifiation was scheduled")
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        guard let alarmUUID = alarm.uuid else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmUUID])
        print("notification was cancelled.")
    }
    
    
}

class AlarmController {
    
    //create singleton
    static let sharedInstance = AlarmController()
    
    weak var delegate: AlarmScheduler?
    
    //create data source of truth
    var alarms: [Alarm] {
        return loadFromPersistentStore()
    }
    
    //MARK: - CRUD
    func createAlarm(fireDate: Date, name: String, enabled: Bool) {
    let _ = Alarm(fireDate: fireDate, name: name, enabled: enabled)
       
        //saveToPersistentStore
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate newFireDate: Date, name newName: String, enabled newEnabled: Bool){
        alarm.fireDate = newFireDate
        alarm.name = newName
        alarm.enabled = newEnabled
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm){
//        guard let indexOfAlarm =  alarms.firstIndex(of: alarm) else { return }
//        alarms.remove(at: indexOfAlarm)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(alarm)
        delegate?.cancelUserNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm){
        alarm.enabled = !alarm.enabled
        
        if alarm.enabled {
            delegate?.scheduleUserNotifications(for: alarm)
        } else {
            delegate?.cancelUserNotifications(for: alarm)
        }
        
        saveToPersistentStore()
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

extension AlarmController: AlarmScheduler {
    //Conform you AlarmController Class  to the AlasrmScheduler protocol. Notice how the compiler does not make you implement the schedule and cancel functions from the protocol. This is because by adding an extension to the protocol, we have created default implementation of these functions for all classes that confrom to the protocol.
}
