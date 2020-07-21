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
    var cell: UICollectionViewCell? = nil
    
    @IBOutlet weak var Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func update(caller: UICollectionViewCell, habit: JayData.HabitLocal) {
        Label.text = habit.name
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        let view = caller.contentView
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: (view.center.x - view.bounds.width / 2) - 8, y: view.center.x - view.bounds.width / 2, width: layer.bounds.width + 12, height: layer.bounds.width + 12), cornerRadius: 10).cgPath
    }
}
