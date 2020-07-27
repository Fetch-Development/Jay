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
    
    @IBOutlet weak var presetsStackView: UIStackView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var wantedSelector: UISegmentedControl!
    
    var reload : () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in presetsStackView.subviews{
            let ovrvLayer = view.layer
            ovrvLayer.masksToBounds = false
            ovrvLayer.cornerRadius = 15
            ovrvLayer.shadowColor = UIColor.black.cgColor
            ovrvLayer.shadowOpacity = 0.2
            ovrvLayer.shadowRadius = 8
            ovrvLayer.shadowPath = UIBezierPath(roundedRect: CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.frame.width, height: view.bounds.height + 5), cornerRadius: 10).cgPath
            ovrvLayer.shouldRasterize = true
            ovrvLayer.rasterizationScale = UIScreen.main.scale
        }
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
