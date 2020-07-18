//
//  DefaultCollectionViewDelegate.swift
//  celendar
//
//  Created by Vova on 16.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

protocol CalendarViewSelectableItemDelegate: class, UICollectionViewDelegateFlowLayout {
    var didSelectItem: ((_ indexPath: IndexPath) -> Void)? { get set }
}

class CalendarCollectionViewDelegate: NSObject, CalendarViewSelectableItemDelegate {
    var didSelectItem: ((_ indexPath: IndexPath) -> Void)?
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let offset = Calendar.current.component(.day, from: TodayHabitCardView.derivedData.createdAt) - 1
        let cell = collectionView.cellForItem(at: indexPath)
        //MARK: UNOPTIMAL CODE – WORTH RESHAPING
        if (indexPath.item >= TodayHabitCardView.startingWeekday - 1 && indexPath.item <= (TodayHabitCardView.today - TodayHabitCardView.startingWeekday - 1))
            && ((indexPath.item - offset) - (TodayHabitCardView.startingWeekday - 1) <
                TodayHabitCardView.derivedData.history.habits.endIndex && (indexPath.item - offset) -
                (TodayHabitCardView.startingWeekday - 1) >= 0)
        {
            cell?.contentView.subviews[0].removeFromSuperview()
            var imageView = UIImageView()
            switch TodayHabitCardView.derivedData.history.habits[(indexPath.item - offset) -
                (TodayHabitCardView.startingWeekday - 1)].state{
            case .completed:
                imageView = UIImageView(image: UIImage(systemName: "slash.circle"))
                TodayHabitCardView.derivedData.history.habits[(indexPath.item - offset) -
                    (TodayHabitCardView.startingWeekday - 1)].state = .untouched
            case .untouched:
                imageView = UIImageView(image: UIImage(systemName: "smallcircle.circle"))
                TodayHabitCardView.derivedData.history.habits[(indexPath.item - offset) -
                    (TodayHabitCardView.startingWeekday - 1)].state = .incompleted
            case .incompleted:
                imageView = UIImageView(image: UIImage(systemName: "smallcircle.fill.circle"))
                TodayHabitCardView.derivedData.history.habits[(indexPath.item - offset) -
                    (TodayHabitCardView.startingWeekday - 1)].state = .completed
            default:
                fatalError("Unknown state")
            }
            //Setting cell's tint color
            imageView.tintColor = .darkGray
            cell!.contentView.addSubview(imageView)
            imageView.centerInSuperview()
            imageView.widthToSuperview()
            imageView.heightToSuperview()
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath)
    //        if cell?.backgroundColor == .red {
    //            cell?.backgroundColor = .gray
    //        } else {
    //            cell?.backgroundColor = .red
    //        }
    //    }
    
}
