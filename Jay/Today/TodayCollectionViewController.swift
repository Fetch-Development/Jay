//
//  TodayCollectionViewController.swift
//  Jay
//
//  Created by Vova on 14.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

var DataProvider = JayData()
var cellID: [Int] = DataProvider.getAvaliableCellsIDs()
var vc: UICollectionViewController? = nil

class TodayCollectionViewController: UICollectionViewController {
    
    
    private lazy var delegate: CollectionViewSelectableItemDelegate = {
        let res = CustomGriddedContentCollectionViewDelegate()
        res.didSelectItem = { index in
            vc?.navigationController?.present(getDetailsVC(id: cellID[index.item]), animated: true, completion: nil)
            }
        return res
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = self
        self.collectionView.register (
            HabitCollectionViewCell.nib,
            forCellWithReuseIdentifier: HabitCollectionViewCell.reuseID
        )
        
        self.collectionView.register (
            ReminderCollectionViewCell.nib,
            forCellWithReuseIdentifier: ReminderCollectionViewCell.reuseID
        )
        
        updatePresentationStyle()
    }
    
    private func updatePresentationStyle() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize.zero
        }
        collectionView.delegate = delegate
        collectionView.performBatchUpdates({
            collectionView.reloadData()
        }, completion: nil)
    }
    
    // add button reload seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "addButton" else { return }
        guard let destination = segue.destination as? AddViewController else { return }
        destination.reload = {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension TodayCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellID.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = DataProvider.id2cell(id: cellID[indexPath.item])
        
        switch data.type {
        case .habit:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HabitCollectionViewCell.reuseID,
                for: indexPath) as? HabitCollectionViewCell
                else {
                    fatalError("Wrong cell")
            }
            cell.update(habit: data.obj as! JayData.Habit)
            return cell
        case .reminder:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReminderCollectionViewCell.reuseID,
                for: indexPath) as? ReminderCollectionViewCell
                else {
                    fatalError("Wrong cell")
            }
            cell.update(reminder: data.obj as! JayData.Reminder)
            return cell
        }
    }
}

