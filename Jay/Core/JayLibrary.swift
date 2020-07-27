//
//  JayLibrary.swift
//  Jay
//
//  Created by Aydar Nasibullin on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation
import Lottie

public class Jay {
    
    //Colors
    public static let successGreenColor = UIColor.init(displayP3Red: 120 / 255, green: 197 / 255, blue: 129 / 255, alpha: 1)
    //Function, called when user presses habit-completing button
    public static func progressAppend(data: inout JayData.HabitLocal, animationView: AnimationView, afterAction: @escaping () -> Void) {
        (data.wanted - data.completed == 1) ? (data.state = .completed) : (data.state = .incompleted)
        data.completed += 1
        animationView.isHidden = false
        Jay.playLottieAnimation (
            view: animationView,
            named: "CheckedDone",
            after: { afterAction() }
        )
    }
    //Returning card instance
    public static func getCard(from: JayData.HabitLocal) -> JayData.JayOverview.Card{
        if (from.createdAt.distance(to: Date()).isLess(than: 200000)) {
            return JayData.JayOverview.beginCard
        } else if from.stats!.donePercentage > 85 { //Get here in case overall completion is over 85%
            return JayData.JayOverview.amazingResultsCard
        } else if false { //Get here in case user's progress increased
            return JayData.JayOverview.progressCard
        } else if false { //Get here in case user's progress stayed the same
            return JayData.JayOverview.stagnationCard
        } else if false { //Get here in case user's progress decreased
            return JayData.JayOverview.degradationCard
        } else {
            return JayData.JayOverview.commonCard
        }
    }
    //Sending haptic feedback
    public static func sendSuccessHapticFeedback(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    //Obtaining text width
    public static func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
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
    //Playing animation
    public static func playLottieAnimation(view: AnimationView, named: String, after: @escaping () -> Void) {
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.isHidden = false
        view.animation = Animation.named(named)
        view.loopMode = .playOnce
        view.play { _ in
            after()
        }
    }
    //Animating scale
    public static func animateScale(view: UIView){
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        },
                       completion: { _ in
                        view.isHidden = true
        })
    }
    
    // DB time format
     public static func removeTimeFrom(date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 0
        components.minute = 0
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    public static func getDayOfMonth(date: Date, index: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: date)
        
        components.day = index + 1
        components.hour = 23
        components.minute = 59
        
        let date = Calendar.current.date(from: components)
        return date!
    }
}
