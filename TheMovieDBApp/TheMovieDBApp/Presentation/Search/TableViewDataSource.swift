//
//  TableViewDataSource.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 31.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

final class TableViewDataSource<Model, Cell>: NSObject, UITableViewDataSource where Cell: MoviesCell {
    
    // MARK: - Types
    
    typealias CellConfigurator = (Model, MoviesCell) -> Void
    
    // MARK: - Constants
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    // MARK: - IBOutlet
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var models: [Model]
    
    // MARK: - Initializers
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    // MARK: - UIViewController(*)
    
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

        cellConfigurator(model, cell as! MoviesCell)

        return cell
    }
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
}
