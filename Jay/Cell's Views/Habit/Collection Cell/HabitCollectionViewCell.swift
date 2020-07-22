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
    
    @IBOutlet weak var successAnimationView: AnimationView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBAction func buttonPressed(_ sender: Any) {
        if derivedData!.state != .completed{
            Jay.progressAppend(data: &(derivedData)!, animationView: successAnimationView, afterAction: {self.update()})
        }
    }
    
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
    
//    func progressAppend(){
//        Jay.playLottieAnimation(view: successAnimationView, named: "CheckedDone", after: {
//            Jay.animateScale(view: self.successAnimationView) })
//    }
    
    func update(){
        progressLabel.text = String(derivedData!.completed) + "/" + String(derivedData!.wanted)
        if derivedData!.state == .completed {
            button.setBackgroundImage(UIImage(named: "HabitIconDone"), for: .normal)
            progressLabel.textColor = Jay.successGreenColor
        } else {
            button.setBackgroundImage(UIImage(named: "HabitIcon"
            + String(derivedData!.completed) + "."
            + String(derivedData!.wanted)), for: .normal)
            Jay.animateScale(view: successAnimationView)
        }
    }
    
    func draw(caller: UICollectionViewCell, habit: JayData.HabitLocal) {
        derivedData = habit
        Label.text = habit.name
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        let view = caller.contentView
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: (view.center.x - view.bounds.width / 2) - 8, y: view.center.x - view.bounds.width / 2, width: layer.bounds.width + 12, height: layer.bounds.width + 12), cornerRadius: 10).cgPath
        update()
    }
}
