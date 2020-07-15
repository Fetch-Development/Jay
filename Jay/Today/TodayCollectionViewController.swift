//
//  TodayCollectionViewController.swift
//  Jay
//
//  Created by Vova on 14.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

var datasource: [Any] = CellsProvider.get()

class TodayCollectionViewController: UICollectionViewController {
    
    
    private var Delegate: CollectionViewSelectableItemDelegate = {
        let res = CustomGriddedContentCollectionViewDelegate()
        res.didSelectItem = { _ in
            print("Item selected")
        }
        return res
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register (
            HabitCollectionViewCell.nib,
            forCellWithReuseIdentifier: HabitCollectionViewCell.reuseID
        )
        
        self.collectionView.register (
                   ReminderCollectionViewCell.nib,
                   forCellWithReuseIdentifier: ReminderCollectionViewCell.reuseID
               )
        
        collectionView.contentInset = .zero
        updatePresentationStyle()
    }
    
    private func updatePresentationStyle() {
        collectionView.delegate = Delegate
        collectionView.performBatchUpdates({
            collectionView.reloadData()
        }, completion: nil)
    }
    
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension TodayCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let item = datasource[indexPath.item] as? Habit {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HabitCollectionViewCell.reuseID,
                for: indexPath) as? HabitCollectionViewCell
                else {
                    fatalError("Wrong cell")
            }
            cell.update(habit: item)
            return cell
        } else if let item = datasource[indexPath.item] as? Reminder {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReminderCollectionViewCell.reuseID,
                for: indexPath) as? ReminderCollectionViewCell
                else {
                    fatalError("Wrong cell")
            }
            cell.update(reminder: item)
            return cell
        }
    fatalError("Wrong cell")
    }
}

