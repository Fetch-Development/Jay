//
//  JayData.swift
//  CardExtendedViewPrototype
//
//  Created by Aydar Nasibullin on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

var eventStore: EKEventStore!
var reminderList: [EKReminder]!
var flag = true
var reminderDict: [String: JayData.Reminder] = [:]


class HabitHistoricalValue: Object {
    @objc dynamic var completed = 0
    @objc dynamic var wanted = 0
    @objc dynamic var state = ""
    @objc dynamic var date = Date()
}


class Habit: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var lastUpdate = Date()
    @objc dynamic var completed = 0
    @objc dynamic var wanted = 0
    @objc dynamic var state = ""
    @objc dynamic var archived = false
}




class JayData {
    // MARK: - Habit
    // This is the main Habit data structure
    public struct HabitLocal {
        var name: String
        var createdAt: Date
        var lastUpdate: Date
        var completed: Int
        var wanted: Int
        var state: JayHabitState
        var archived: Bool
    }
    
    public struct JayHabitHistoricalValue {
        var completed: Int
        var wanted: Int
        var state: JayHabitState
    }
    
    public enum JayHabitState {
        case completed
        case incompleted
        case untouched
        case unknown
    }
    
    
    // MARK: - Reminder
    // This is the main Reminder data structure
    public struct Reminder {
        var name: String
        var state: Bool
    }
    
    func getReminders() {
        eventStore = EKEventStore()
        reminderList = [EKReminder]()
        eventStore.requestAccess(to: EKEntityType.reminder) { (granted: Bool, error: Error?) -> () in
            if granted {
                let predicate = eventStore.predicateForReminders(in: nil)
                eventStore.fetchReminders(
                    matching: predicate,
                    completion: { (reminders: [EKReminder]?) -> Void in
                        reminderList = reminders
                        flag = false
                })
            } else {
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }
    }
    
    // MARK: Generic Struct
    public struct Generic {
        var type: DataType
        var obj: Any
    }
    
    public enum DataType {
        case habit
        case reminder
    }
    
    func getHabitState(_ state: String) -> JayHabitState {
        let map: [String: JayHabitState] = ["completed": .completed,
                                            "incompleted": .incompleted,
                                            "untouched": .untouched,
                                            "unknown": .unknown]
        return map[state]!
    }
    
    func getHabitHistory() {
        // TODO: Make habit history
    }
    
    func class2struct(habit: Habit) -> Generic {
        let target = HabitLocal(
            name: habit.name,
            createdAt: habit.createdAt,
            lastUpdate: habit.lastUpdate,
            completed: habit.completed,
            wanted: habit.wanted,
            state: self.getHabitState(habit.state),
            archived: habit.archived
        )
        return Generic(type: .habit, obj: target)
    }
    // MARK: - Data Provider
    
    func getAvaliableCellsIDs() -> [String] {
        // Habit
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        let db = try! Realm()
        let habits = db.objects(Habit.self).filter("archived = false")
        var cellIDs = [String]()
        for habit in habits {
            cellIDs.append(habit.id)
        }
        
        // Reminder
        getReminders()
        while flag {
            _ = 2 + 2 // pass
        }
        for reminder in reminderList {
            if !reminder.isCompleted {
                reminderDict[reminder.calendarItemIdentifier] = Reminder(name: reminder.title, state: reminder.isCompleted)
                cellIDs.append(reminder.calendarItemIdentifier)
            }
        }
        print(reminderList!)
        
        return cellIDs
    }
    
    
    // FIXME: Make actual API
    func id2cell(id: String) -> Generic {
        let db = try! Realm()
        if let item = db.objects(Habit.self).filter("id = '\(id)'").first {
            return self.class2struct(habit: item)
        }
        return Generic(type: .reminder, obj: reminderDict[id] as Any)
        
        
    }
    
    func state2string(_ state: JayHabitState) -> String {
        let map: [JayHabitState: String] = [.completed: "completed",
                                            .incompleted: "incompleted",
                                            .untouched: "untouched",
                                            .unknown: "unknown"]
        return map[state]!
    }
    
    func habitLocal2Habit(ID: String?, item: HabitLocal) -> Habit {
        var id = ""
        if ID == nil {
            id = UUID().uuidString
        } else {
            id = ID!
        }
        let target = Habit()
        
        target.id = id
        target.name = item.name
        if ID == nil {
            target.createdAt = Date()
        } else {
            target.createdAt = item.createdAt
        }
        target.lastUpdate = Date()
        target.completed = item.completed
        target.wanted = item.wanted
        target.state = self.state2string(item.state)
        target.archived = item.archived
        
        return target
    }
    
    func add(type: DataType, obj: Any) {
        switch type {
        case .habit:
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            let target = self.habitLocal2Habit(ID: nil, item: obj as! HabitLocal)
            let db = try! Realm()
            try! db.write {
                db.add(target)
            }
            
        case .reminder:
            // FIXME : add reminder
            break
        }
    }
    
    func update(id: String, obj: Any) {
        if obj is HabitLocal {
            
            let db = try! Realm()
            
            let item = db.objects(Habit.self).filter("id = '\(id)'").first
            let target = self.habitLocal2Habit(ID: id, item: obj as! HabitLocal)
            
            try! db.write {
                db.delete(item!)
                db.add(target)
            }
        }
    }
}
