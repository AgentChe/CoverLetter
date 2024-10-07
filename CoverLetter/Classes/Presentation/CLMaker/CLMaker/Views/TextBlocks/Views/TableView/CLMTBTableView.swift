//
//  CLMTBTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

final class CLMTBTableView: UITableView {
    lazy var elements = [CLMTBTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMTBTableView {
    func setup(elements: [CLMTBTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CLMTBTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .header:
            return dequeueReusableCell(withIdentifier: String(describing: CLMTBTableHeaderCell.self), for: indexPath)
        case .textBlock(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CLMTBTableCell.self), for: indexPath) as! CLMTBTableCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CLMTBTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CLMTBTableView {
    func initialize() {
        register(CLMTBTableHeaderCell.self, forCellReuseIdentifier: String(describing: CLMTBTableHeaderCell.self))
        register(CLMTBTableCell.self, forCellReuseIdentifier: String(describing: CLMTBTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
