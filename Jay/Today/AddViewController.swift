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
                datasource.append(Habit(name: NameField.text!, state: false))
            } else {
                datasource.append(Reminder(name: NameField.text!, state: false))
            }
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
