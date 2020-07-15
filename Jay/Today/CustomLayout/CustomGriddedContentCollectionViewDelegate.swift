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
    private let minimumItemSpacing: CGFloat = 15
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGSize
        if datasource[indexPath.item] is Reminder {
            let itemWidth = collectionView.bounds.width - (sectionInsets.left + sectionInsets.right)
            itemSize = CGSize(width: itemWidth, height: 60)
        } else {
            let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
            let availableWidth = collectionView.bounds.width - paddingSpace
            let widthPerItem = Int(availableWidth / itemsPerRow)
            itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        }
        return itemSize
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
