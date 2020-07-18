//
//  DefaultCollectionViewDelegate.swift
//  celendar
//
//  Created by Vova on 16.07.2020.
//  Copyright © 2020 ChernykhVladimir. All rights reserved.
//

import UIKit

protocol CelendarViewSelectableItemDelegate: class, UICollectionViewDelegateFlowLayout {
    var didSelectItem: ((_ indexPath: IndexPath) -> Void)? { get set }
}

class CelendarCollectionViewDelegate: NSObject, CelendarViewSelectableItemDelegate {
    var didSelectItem: ((_ indexPath: IndexPath) -> Void)?
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let nextColor: [UIColor: UIColor] = [.gray: .blue,
                                             .blue: .red,
                                             .red: .gray]
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = nextColor[cell?.backgroundColor ?? .gray]
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
