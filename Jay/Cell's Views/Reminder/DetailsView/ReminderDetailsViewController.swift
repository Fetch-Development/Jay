//
//  ReminderDetailsViewController.swift
//  Jay
//
//  Created by Vova on 17.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import UIKit

class ReminderDetailsViewController: UIViewController {

    @IBOutlet weak var CloseButton: UIBarButtonItem!
    @IBOutlet weak var label: UILabel!
    
    var reminder: Reminder? = nil
    
    override func viewDidLoad() {
        label.text = reminder?.name ?? "no data"
        super.viewDidLoad()
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
