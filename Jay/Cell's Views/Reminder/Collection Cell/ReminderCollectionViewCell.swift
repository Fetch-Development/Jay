//
//  ReminderCollectionViewCell.swift
//  Jay
//
//  Created by Vova on 15.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

class ReminderCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ReminderCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: ReminderCollectionViewCell.self), bundle: nil)
    
    var reminderID: Int? = nil
    var reminder: JayData.Reminder? = nil
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    
    @IBAction func statusButtonPressed(_ sender: Any) {
        self.reminder!.state.toggle()
        // Status Button
        update()
        DataProvider.update(id: reminderID!, obj: reminder!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setData(id: Int, reminder: JayData.Reminder) {
        self.reminderID = id
        self.reminder = reminder
        update()
    }
    
    func update() {
        // Lable
        Label.text = reminder?.name
        
        // Status Button
        switch reminder!.state {
        case true:
            statusButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        case false:
            statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
}
