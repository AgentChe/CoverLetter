//
//  SelectCityTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectCityTableView: UITableView {
    private lazy var elements = [SelectCityTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SelectCityTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectCityTableView {
    func setup(elements: [SelectCityTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SelectCityTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SelectCityTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = elements[indexPath.row].name
        let cell = dequeueReusableCell(withIdentifier: String(describing: SelectCityTableCell.self), for: indexPath) as! SelectCityTableCell
        cell.setup(name: name)
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectCityTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SelectCityTableView {
    func initialize() {
        register(SelectCityTableCell.self, forCellReuseIdentifier: String(describing: SelectCityTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
