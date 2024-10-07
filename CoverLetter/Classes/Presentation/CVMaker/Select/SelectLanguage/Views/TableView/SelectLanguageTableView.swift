//
//  SelectLanguageTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectLanguageTableView: UITableView {
    private lazy var elements = [String]()
    
    private lazy var didSelectTrigger = PublishRelay<String>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectLanguageTableView {
    func setup(elements: [String]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<String> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SelectLanguageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = elements[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: String(describing: SelectLanguageTableCell.self), for: indexPath) as! SelectLanguageTableCell
        cell.setup(name: name)
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectLanguageTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SelectLanguageTableView {
    func initialize() {
        register(SelectLanguageTableCell.self, forCellReuseIdentifier: String(describing: SelectLanguageTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
