//
//  TableViewDataSource.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 31.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

final class TableViewDataSource<Model, Cell>: NSObject, UITableViewDataSource where Cell: UITableViewCell {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? Cell {
            cellConfigurator(model, cell)
        }

        return cell
    }
    
}
