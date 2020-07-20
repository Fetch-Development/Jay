//
//  HabitCollectionViewCell.swift
//  Jay
//
//  Created by Vova on 15.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: HabitCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: HabitCollectionViewCell.self), bundle: nil)
    
    @IBOutlet weak var Label: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
        clipsToBounds = true
        layer.cornerRadius = 4
        Label.font = UIFont.systemFont(ofSize: 18)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func update(habit: JayData.Habit) {
        Label.text = habit.name
    }
}

