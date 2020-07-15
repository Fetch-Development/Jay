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
    
    
    @IBOutlet weak var Label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
        clipsToBounds = true
        layer.cornerRadius = 4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func update(reminder: Reminder) {
        Label.text = reminder.name
    }
}
