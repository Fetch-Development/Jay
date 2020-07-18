//
//  JayLibrary.swift
//  Jay
//
//  Created by Aydar Nasibullin on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation

public class Jay {
    
    //Function to quickly create dates
    public static func dateFromComponents(day: Int, month: Int, year: Int) -> Date{
        var components = DateComponents()
        let calendar = Calendar.current
        components.day = day
        components.month = month
        components.year = year
        let newDate = calendar.date(from: components)!
        return newDate
    }
    //Function to quickly return current date as string
    public static func getCalendarDateData() -> (String, String) {
        let now = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return (monthFormatter.string(from: now), yearFormatter.string(from: now))
    }
    //Function to quickly return days in given month
    public static func getDaysInMonth(month: Int) -> Int{
        let dateComponents = DateComponents(year: 2015, month: 7)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}
