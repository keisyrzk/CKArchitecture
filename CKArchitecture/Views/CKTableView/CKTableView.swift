//
//  CKTableView.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit
import Combine

// custom TableView implementation that handles any data input (generic `T`)
class CKTableView<T>: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // input table's items
    private var items: [T] = []
    // publisher that emits the selected cell's associated data on cell click
    var onCellClickPublisher = PassthroughSubject<T, Never>()
    
    init(items: [T]) {
        super.init(frame: .zero, style: .plain)
        self.items = items
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        registerCells()
    }
    
    // register all possible cell types so the Table View can handle them
    private func registerCells() {
        register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: PersonTableViewCell.identifier)
        register(UINib(nibName: "PlanetTableViewCell", bundle: nil), forCellReuseIdentifier: PlanetTableViewCell.identifier)
        register(UINib(nibName: "FilmTableViewCell", bundle: nil), forCellReuseIdentifier: FilmTableViewCell.identifier)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cellIdentifier = String(describing: type(of: item))
        let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let configurableCell = cell as? ConfigurableCell {
            configurableCell.configureAny(item: item)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellClickPublisher.send(items[indexPath.row])
    }
}

protocol ConfigurableCell {
    func configureAny(item: Any)
}

protocol TypedConfigurableCell: ConfigurableCell {
    associatedtype DataType
    func configure(item: DataType)
}

