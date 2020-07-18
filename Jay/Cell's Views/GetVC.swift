//
//  GetVC.swift
//  Jay
//
//  Created by Vova on 18.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import UIKit

func getDetailsVC(id: Int) -> UIViewController {
    let data = DataProvider.id2cell(id: id)
    
    switch data.type {
    case .habit:
        let vc = UIViewController()
        let habitView: TodayHabitCardView =
            TodayHabitCardView(data: data.obj as! JayData.Habit, frame: vc.view.frame)
        
        habitView.commonInit()
        vc.view.addSubview(habitView)
        habitView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return vc
    case .reminder:
        let detailsVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ReminderDetailsViewController")
                as? ReminderDetailsViewController
        
        detailsVC?.reminder = data.obj as? JayData.Reminder
        return detailsVC!
    }
}
