//
//  CLsGroupsTableView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CLsGroupsTableView: UITableView {
    private lazy var elements = [CLsGroup]()
    
    private lazy var didSelectGroupTrigger = PublishRelay<CLsGroup>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLsGroupsTableView {
    func setup(elements: [CLsGroup]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectGroup: Signal<CLsGroup> {
        didSelectGroupTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CLsGroupsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CLsGroupsTableCell.self), for: indexPath) as! CLsGroupsTableCell
        cell.setup(clGroup: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CLsGroupsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectGroupTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension CLsGroupsTableView {
    func initialize() {
        register(CLsGroupsTableCell.self, forCellReuseIdentifier: String(describing: CLsGroupsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
