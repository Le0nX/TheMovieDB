//
//  CollectionViewDataSource.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

final class CollectionViewDataSource<Model, Cell>: NSObject,
UICollectionViewDataSource where Cell: UICollectionViewCell {
    
    // MARK: - Types
    
    typealias CellConfigurator = (Model, Cell) -> Void
    
    // MARK: - Constants
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    // MARK: - Private Properties
    
    public var models: [Model]
    
    // MARK: - Initializers
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
        
    // MARK: - Public methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? Cell {
            cellConfigurator(model, cell)
        }

        return cell
    }
    
}
