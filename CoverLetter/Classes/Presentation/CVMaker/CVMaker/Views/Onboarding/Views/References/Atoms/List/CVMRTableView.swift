//
//  CVMRTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMRTableView: UITableView {
    var didDelete: ((Reference) -> Void)?
    var didAddMore: (() -> Void)?
    
    lazy var elements = [CVMRTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMRTableView {
    func setup(elements: [CVMRTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CVMRTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .title:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerTitleCell.self), for: indexPath) as! CVMakerTitleCell
            cell.setup(title: "CVMaker.References.List.Title".localized)
            return cell
        case .reference(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMRTableCell.self), for: indexPath) as! CVMRTableCell
            cell.setup(reference: element)
            cell.didDelete = { [weak self] in
                self?.didDelete?(element)
            }
            return cell
        case .addMore:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerAddCell.self), for: indexPath) as! CVMakerAddCell
            cell.didTap = { [weak self] in
                self?.didAddMore?()
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CVMRTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CVMRTableView {
    func initialize() {
        register(CVMakerTitleCell.self, forCellReuseIdentifier: String(describing: CVMakerTitleCell.self))
        register(CVMRTableCell.self, forCellReuseIdentifier: String(describing: CVMRTableCell.self))
        register(CVMakerAddCell.self, forCellReuseIdentifier: String(describing: CVMakerAddCell.self))
        
        dataSource = self
        delegate = self
    }
}
