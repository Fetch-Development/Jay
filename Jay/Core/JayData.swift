//
//  JayData.swift
//  Jay
//
//  Created by Chernykh Vladimir on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

var eventStore: EKEventStore!
var reminderList: [EKReminder]!
var flag = true
var reminderDict: [String: JayData.Reminder] = [:]

class HabitHistory: Object {
    @objc dynamic var id = ""
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

public class JayData {
    public class JayOverview {
        public struct Card {
            var imageName: String
            var header: String
            var description: String
        }
    /**
     Image names for use:
        – checkmark.seal.fill (галка)
        – rosette (медаль)
        – sparkles (звездочки)
        – xmark.seal.fill (крестик)
        – arrow.up.right (прогресс)
        – arrow.down.right (деградация)
        – arrow.right (стагнация)
        – arrow.turn.right.up (начало)
     */
        public static let beginCard =
        Card(
            imageName: "arrow.turn.right.up",
            header: "Get ready",
            description: "You've just begun with your habit.\nIt's time you did that!"
        )
        public static let commonCard =
        Card(
            imageName: "chart.bar.fill",
            header: "Add more data",
            description: "More data required for this one"
        )
        public static let progressCard =
        Card(
            imageName: "arrow.up.right",
            header: "You're doing great",
            description: "Your progress has increased over the recent time.\nGreat job!"
        )
        public static let stagnationCard =
        Card(
            imageName: "arrow.right",
            header: "You're on the level",
            description: "Your progress is just the same as it was.\nTime to push the boundaries!"
        )
        public static let degradationCard =
        Card(
            imageName: "arrow.down.right",
            header: "You're struggling",
            description: "Your progress has decreased.\nGet back on track!"
        )
        public static let amazingResultsCard =
        Card(
            imageName: "sparkles",
            header: "Amazing!",
            description: "You're doing great completing your habit!\nTime to celebrate!"
        )
    }
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
        var stats: HabitStatistics?
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
        case blank
    }
    
    
    // MARK: - Reminder
    // This is the main Reminder data structure
    public struct Reminder {
        var name: String
        var done: Bool
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
                        reminderList += reminders!
                        flag = false
                })
            } else {
                flag = false
                print("The app is not permitted to access reminders, make sure you've granted permission in the settings and try again")
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
        let db = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let habits = db.objects(Habit.self).filter("archived = false")
        var cellIDs = [String]()
        for habit in habits {
            cellIDs.append(habit.id)
            
            // reset if needed
            if db.objects(HabitHistory.self)
                .filter("id = '\(habit.id)' AND date >= %@ AND date < %@", Jay.removeTimeFrom(date: Date()), Date()).first == nil {
                var target = self.class2struct(habit: habit).obj as! HabitLocal
                target.completed = 0
                target.state = .untouched
                update(id: habit.id, obj: target)
            }
        }
        cellIDs.sort()
        
        // Reminder
        cellIDs += Array(reminderDict.keys)
        getReminders()
        while flag {
            _ = 2 + 2 // pass
        }
        for reminder in reminderList {
            if !reminder.isCompleted {
                reminderDict[reminder.calendarItemIdentifier] = Reminder(name: reminder.title, done: reminder.isCompleted)
                cellIDs.append(reminder.calendarItemIdentifier)
            }
        }
        
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
            let target = self.habitLocal2Habit(ID: nil, item: obj as! HabitLocal)
            let db = try! Realm()
            try! db.write {
                db.add(target)
            }
            let temp = obj as! HabitLocal
            let historyTarget = HabitHistory(value: ["id": target.id,
                                                     "completed": temp.completed,
                                                     "wanted": temp.wanted,
                                                     "state": state2string(temp.state),
                                                     "date": Date()])
            
            try! db.write {
                db.add(historyTarget)
            }
            
        case .reminder:
            // FIXME: add reminder
            break
        }
    }
    
    func update(id: String, obj: Any) {
        if obj is HabitLocal {
            let db = try! Realm()
            
            // Habit DB
            let item = db.objects(Habit.self).filter("id = '\(id)'").first
            let target = self.habitLocal2Habit(ID: id, item: obj as! HabitLocal)
            
            try! db.write {
                db.delete(item!)
                db.add(target)
            }
            
            // History DB
            if let history = db.objects(HabitHistory.self)
                .filter("id = '\(id)' AND date >= %@ AND date < %@", Jay.removeTimeFrom(date: Date()), Date()).first {
                try! db.write {
                    db.delete(history)
                }
            }
            let temp = obj as! HabitLocal
            let historyTarget = HabitHistory(value: ["id": id,
                                                     "completed": temp.completed,
                                                     "wanted": temp.wanted,
                                                     "state": state2string(temp.state),
                                                     "date": Date()])
            
            try! db.write {
                db.add(historyTarget)
            }
        }
    }
    
    func delete(id: String) {
        if reminderDict[id] == nil {
            let db = try! Realm()
            let item = db.objects(Habit.self).filter("id = '\(id)'").first
            try! db.write {
                db.delete(item!)
            }
            let history = db.objects(HabitHistory.self).filter("id = '\(id)'")
            try! db.write {
                db.delete(history)
            }
        }
    }
    
    func archive(id: String) {
        if reminderDict[id] == nil {
            let db = try! Realm()
            let item = db.objects(Habit.self).filter("id = '\(id)'").first
            try! db.write {
                item?.archived = true
            }
        }
    }
    
    func getChartInfo(id: String) -> [Int] {
        let db = try! Realm()
        let items = db.objects(HabitHistory.self).filter("id = '\(id)'").sorted(byKeyPath: "date")
        var target = [0]
        for item in items {
            target.append(10 + 5 * item.completed)
        }
        return target
    }
    
    struct HabitStatistics {
        var completedSum: Int = 0
        var donePercentage: Int = 0
        var len: Int = 0
        var streak: Int = 0
        var best: Int = 0
    }
    
    func getStatistics(id: String) -> HabitStatistics {
        let db = try! Realm()
        let items = db.objects(HabitHistory.self).filter("id = '\(id)'").sorted(byKeyPath: "date", ascending: false)
        var target = HabitStatistics()
        
        // Streak
        var i = 0
        if items.count > 0 && items[0].state != "completed" {
            i = 1
        }
        while i < items.count && items[i].state == "completed" {
            target.streak += 1
            i += 1
        }
        
        var cnt = 0
        for item in items {
            if item.state == "completed" {
                target.completedSum += 1
                cnt += 1
            } else {
                cnt = 0
            }
            target.best = max(target.best, cnt)
        }
        
        target.len = items.count
        if target.len != 0 {
            target.donePercentage = Int((Double(target.completedSum) / Double(target.len)) * 100)
        }
        
        return target
    }
    
    func getCalendarStatus(id: String, date: Date) -> JayHabitState {
           let db = try! Realm()

           if let history = db.objects(HabitHistory.self).filter("id = '\(id)' AND date >= %@ AND date < %@", Jay.removeTimeFrom(date: date), date).first {
               return getHabitState(history.state)
           }
           return .unknown
       }
}
