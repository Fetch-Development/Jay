//
//  JayData.swift
//  CardExtendedViewPrototype
//
//  Created by Aydar Nasibullin on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation

class JayData {
    // MARK: - Habit
    // This is the main Habit data structure
    public struct Habit {
        var name: String
        var createdAt: Date
        var completed: Int
        var wanted: Int
        var state: JayHabitState
        var history: JayHabitHistory
    }
    public struct JayHabitHistoricalValue {
        var completed: Int
        var wanted: Int
        var state: JayHabitState
    }
    public struct JayHabitHistory {
        var habits: [JayHabitHistoricalValue]
    }
    public enum JayHabitState{
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
        var notificationId: String? = nil
    }
    
    // MARK: Gemeric Struct
    public struct Generic {
        var type: DataType
        var obj: Any
    }
    
    public enum DataType {
        case habit
        case reminder
    }
    
    
    // MARK: - Data Provider

    func getAvaliableCellsIDs() -> [Int] {
        return [1, 2]
    }
    
    // TODO: Make actual API
    private var data: [Int: Generic] = [
        1: Generic(type: .reminder, obj: Reminder(name: "1", state: false)),
        2: Generic(type: .reminder, obj: Reminder(name: "2", state: false))
    ]
    
    // TODO: Make actual API
    func id2cell(id: Int) -> Generic {
        return data[id]!
    }
    
    // TODO: Make actual API
    func add(type: DataType, obj: Any) {
        
    }
}