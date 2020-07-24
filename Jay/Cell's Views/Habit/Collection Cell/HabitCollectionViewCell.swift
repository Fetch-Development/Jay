//
//  HabitCollectionViewCell.swift
//  Jay
//
//  Created by Vova on 15.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit
import Lottie

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: HabitCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: HabitCollectionViewCell.self), bundle: nil)
    var cell: UICollectionViewCell? = nil
    private var derivedData: JayData.HabitLocal?
    private var id: String?
    
    @IBOutlet weak var successAnimationView: AnimationView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBAction func buttonPressed(_ sender: Any) {
        if derivedData!.state != .completed {
            Jay.sendSuccessHapticFeedback()
            Jay.progressAppend(data: &(derivedData)!, animationView: successAnimationView, afterAction: {self.update()})
            DataProvider.update(
                id: self.id!,
                obj: derivedData as Any
            )
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray6
        layer.cornerRadius = 15
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
//        successAnimationView.frame = CGRect(
//            x: button.center.x,
//            y: button.center.y,
//            width: button.frame.width + 150,
//            height: button.frame.height + 150)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
//    func progressAppend(){
//        Jay.playLottieAnimation(view: successAnimationView, named: "CheckedDone", after: {
//            Jay.animateScale(view: self.successAnimationView) })
//    }
    
    func update() {
        progressLabel.text = String(derivedData!.completed) + "/" + String(derivedData!.wanted)
        if derivedData!.state == .completed {
            button.setBackgroundImage(UIImage(named: "HabitIconDone"), for: .normal)
            progressLabel.textColor = Jay.successGreenColor
        } else {
            progressLabel.textColor = nil
            button.setBackgroundImage(UIImage(named: "HabitIcon"
            + String(derivedData!.completed) + "."
            + String(derivedData!.wanted)), for: .normal)
            Jay.animateScale(view: successAnimationView)
        }
    }
    
    func draw(caller: UICollectionViewCell, id: String, habit: JayData.HabitLocal) {
        self.id = id
        self.derivedData = habit
        Label.text = habit.name
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
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: (view.center.x - view.bounds.width / 2) - 8, y: view.center.x - view.bounds.width / 2, width: layer.bounds.width + 12, height: layer.bounds.height + 12), cornerRadius: 10).cgPath
        update()
    }
}
