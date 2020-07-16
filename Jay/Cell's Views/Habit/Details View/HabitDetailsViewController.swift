//
//  HabitDetailsViewController.swift
//  Jay
//
//  Created by Vova on 16.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//


import UIKit

class HabitDetailsViewController: UIViewController {
    
    var habit: Habit? = nil
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var State: UISwitch!
    
    override func viewDidLoad() {
        Label.text = habit?.name ?? "no data"
        State.isOn = habit?.state ?? false
        super.viewDidLoad()
    }
}

