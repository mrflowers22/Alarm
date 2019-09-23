//
//  Alarm+Convenience.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import CoreData

extension Alarm {
    convenience init(fireDate: Date, name: String, enable: Bool, fireTimeAsString: String, uuid: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.name = name
        self.fireDate = fireDate
        self.uuid  = uuid
        self.enable = enable
        var dateASaString: String {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.timeZone = .autoupdatingCurrent
            let dateAsAString = formatter.string(from: fireDate)
            return dateAsAString
        }
        
        
        self.fireTimeAsString = dateASaString
    }
}
