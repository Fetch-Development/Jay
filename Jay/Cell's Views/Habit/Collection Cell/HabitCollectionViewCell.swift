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
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -3, height: 7)
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func update(habit: JayData.Habit) {
        Label.text = habit.name
    }
}

