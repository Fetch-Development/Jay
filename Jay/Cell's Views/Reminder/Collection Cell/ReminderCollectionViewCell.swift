//
//  ReminderCollectionViewCell.swift
//  Jay
//
//  Created by Vova on 15.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit
import Lottie

class ReminderCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ReminderCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: ReminderCollectionViewCell.self), bundle: nil)
    
    var reminderID: String?
    var reminder: JayData.Reminder?
    private var anim = ""
    
    @IBOutlet weak var crossWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var checkedAnimation: AnimationView!
    @IBOutlet weak var crossedLineView: UIView!
    @IBAction func statusButtonPressed(_ sender: Any) {
        Jay.sendSuccessHapticFeedback()
        self.reminder!.done.toggle()
        // Status Button
        update()
        DataProvider.update(id: reminderID!, obj: reminder!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray6
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setData(caller: UICollectionViewCell, remId: String, reminder: JayData.Reminder) {
        self.reminderID = remId
        self.reminder = reminder
        layer.masksToBounds = false
        layer.cornerRadius = 15
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            // light mode detected
            layer.shadowColor = UIColor.black.cgColor
        case .dark:
            // dark mode detected
            layer.shadowColor = UIColor.white.cgColor
        }
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        let view = caller.contentView
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: (view.center.x - view.bounds.width / 2 - 2.5), y: view.center.x - view.bounds.width / 2 , width: layer.bounds.width + 3, height: layer.bounds.height + 5), cornerRadius: 10).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        update(initial: true)
    }

    func update(initial: Bool = false) {
        // Lable
        Label.text = reminder?.name
        
        // Status Button
        if reminder!.done {
            checkedAnimation.isHidden = false
            statusButton.isHidden = true
            Jay.playLottieAnimation(view: checkedAnimation, named:
                traitCollection.userInterfaceStyle == .light ? "CheckedDoneSmallLight" :
                "CheckedDoneSmallDark", after:
                {
                    self.statusButton.setImage(UIImage(named: "TickedReminder"), for: .normal)
                    self.checkedAnimation.isHidden = true
                    self.statusButton.isHidden = false
                })
            self.layoutIfNeeded()
            self.crossWidthConstraint.constant = Jay.textWidth(font: .systemFont(ofSize: 17.0, weight: .regular), text: Label.text!) + 10
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.layoutIfNeeded()
            },
                           completion: { _ in
                            //self.crossedLineView.isHidden = true
            })
        } else {
            crossWidthConstraint.constant = 0
            statusButton.isHidden = false
            statusButton.setImage(UIImage(named: "untickedReminder"), for: .normal)
        }
    }
}
