//
//  SelectProfessionalSkillTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectProfessionalSkillTableView: UITableView {
    private lazy var elements = [ProfessionalSkill]()
    
    private lazy var didSelectTrigger = PublishRelay<ProfessionalSkill>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectProfessionalSkillTableView {
    func setup(elements: [ProfessionalSkill]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<ProfessionalSkill> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SelectProfessionalSkillTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = elements[indexPath.row].name
        let cell = dequeueReusableCell(withIdentifier: String(describing: SelectProfessionalSkillTableCell.self), for: indexPath) as! SelectProfessionalSkillTableCell
        cell.setup(name: name)
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectProfessionalSkillTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SelectProfessionalSkillTableView {
    func initialize() {
        register(SelectProfessionalSkillTableCell.self, forCellReuseIdentifier: String(describing: SelectProfessionalSkillTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
