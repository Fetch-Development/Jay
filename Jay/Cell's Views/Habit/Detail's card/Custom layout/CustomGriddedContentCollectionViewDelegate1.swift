//
//  CustomGriddedContentCollectionViewDelegate.swift
//  celendar
//
//  Created by Vova on 16.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

class CustomGriddedCelendarCollectionViewDelegate: DefaultCollectionViewDelegate {
    private let itemsPerRow: CGFloat = 7
    private let minimumItemSpacing: CGFloat = 10
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGSize
        let paddingSpace = sectionInsets.left + sectionInsets.right
                            + minimumItemSpacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = Int(availableWidth / itemsPerRow)
        itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        
        return itemSize
    }
}
