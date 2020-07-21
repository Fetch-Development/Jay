//
//  AddViewController.swift
//  Jay
//
//  Created by Vova on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var SaveButton: UINavigationItem!
    @IBOutlet weak var CloseButton: UIBarButtonItem!
    
    @IBOutlet weak var TypeSelector: UISegmentedControl!
    @IBOutlet weak var NameField: UITextField!
    
    var reload : () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        if (NameField.text != nil) {
            if TypeSelector.selectedSegmentIndex == 0 {
                // TODO: adding habit to DB
                DataProvider.add(type: .habit, obj: {
                    let data = JayData.HabitLocal (
                        name: NameField.text ?? "no data",
                        createdAt: Date(),
                        lastUpdate: Date(),
                        completed: 0,
                        wanted: 2,
                        state: .untouched,
                        archived: false
                    )
                    return data
                }())
            } else {
                // TODO: adding reminder to DB
                DataProvider.add(type: .reminder, obj: JayData.Reminder(
                    name: NameField.text ?? "no data", state: false)
                )
            }
            cellID = DataProvider.getAvaliableCellsIDs()
            reload()
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
