//
//  CustomGriddedContentCollectionViewDelegate.swift
//  Jay
//
//  Created by Vova on 14.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

class CustomGriddedContentCollectionViewDelegate: DefaultCollectionViewDelegate {
    private let itemsPerRow: CGFloat = 2
    private let minimumItemSpacing: CGFloat = 10
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGSize
        let data = DataProvider.id2cell(id: cellID[indexPath.item])
        
        switch data.type {
        case .reminder:
            let itemWidth = collectionView.bounds.width - (sectionInsets.left + sectionInsets.right)
            itemSize = CGSize(width: itemWidth, height: 60)
        case .habit:
            let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
            let availableWidth = collectionView.bounds.width - paddingSpace
            let widthPerItem = Int(availableWidth / itemsPerRow)
            itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        }
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        //        let share = UIAction(title: "Share",
        //                             image: UIImage(systemName: "square.and.arrow.up")
        //        ) {_ in
        //            // TODO: share action
        //        }
        let reset = UIAction(
            title: "Reset",
            image: UIImage(systemName: "arrow.uturn.left")
        ) {_ in
            let data = DataProvider.id2cell(id: cellID[indexPath.item])
            if data.type == .habit {
                var item = data.obj as! JayData.HabitLocal
                item.completed = 0
                item.state = .untouched
                DataProvider.update(id: cellID[indexPath.item], obj: item)
                vc!.collectionView.reloadData()
            }
        }
        
        
        let archive = UIAction(
            title: "Archive",
            image: UIImage(systemName: "archivebox")
        ) {_ in
            DataProvider.archive(id: cellID[indexPath.item])
            cellID = DataProvider.getAvaliableCellsIDs()
            vc!.collectionView.reloadData()
        }
        
        let delete = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash")
        ) {_ in
            DataProvider.delete(id: cellID[indexPath.item])
            cellID = DataProvider.getAvaliableCellsIDs()
            vc!.collectionView.reloadData()
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil)
        { _ in
            UIMenu(title: "", children: [reset, archive, delete])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
}
