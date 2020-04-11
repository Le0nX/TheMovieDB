//
//  TableContentLayoutFlowDelegate.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// FlowLayout для вида таблицы
final class TableContentLayoutFlowDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.bounds.width

        return CGSize(width: collectionViewSize, height: collectionViewSize / 3)
    }
}
