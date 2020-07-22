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
    
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var wantedSelector: UISegmentedControl!
    
    var reload : () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        if (NameField.text != nil) {
            DataProvider.add(type: .habit, obj: {
                let data = JayData.HabitLocal (
                    name: NameField.text ?? "no data",
                    createdAt: Date(),
                    lastUpdate: Date(),
                    completed: 0,
                    wanted: wantedSelector.selectedSegmentIndex + 1,
                    state: .untouched,
                    archived: false
                )
                return data
            }())
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
