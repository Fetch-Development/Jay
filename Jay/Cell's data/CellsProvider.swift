//
//  CellsProvider.swift
//  Jay
//
//  Created by Vova on 14.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import Foundation

struct CellsProvider {
    static func get() -> [Any] {
        return [
            Habit(name: "1", state: false), Habit(name: "2", state: false),
            Reminder(name: "12345", state: false),
            Reminder(name: "67890", state: false),
            Habit(name: "3", state: false), Habit(name: "4", state: false),
            Habit(name: "5", state: false), Habit(name: "6", state: false),
            Reminder(name: "09876", state: false)
        ]
    }
}
