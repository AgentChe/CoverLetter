//
//  CVMWETableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 24.05.2024.
//

import UIKit

final class CVMWETableView: UITableView {
    var didDelete: ((WorkExperience) -> Void)?
    var didAddMore: (() -> Void)?
    
    lazy var elements = [CVMWETableElement]()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        return formatter
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMWETableView {
    func setup(elements: [CVMWETableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CVMWETableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .title:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerTitleCell.self), for: indexPath) as! CVMakerTitleCell
            cell.setup(title: "CVMaker.WorkExperience.List.Title".localized)
            return cell
        case .workExperience(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerEntityCell<WorkExperience>.self), for: indexPath) as! CVMakerEntityCell<WorkExperience>
            cell.map = { [weak self] workExperience -> [(String, CVMakerEntityCell<WorkExperience>.TextAttrs)] in
                guard let self else { return [] }
                
                var result = [(String, CVMakerEntityCell<WorkExperience>.TextAttrs)]()
                
                if let jobTitle = workExperience.jobTitle {
                    result.append((jobTitle, .first))
                }
                
                if let companyName = element.companyName {
                    result.append((companyName, .second))
                }
                
                if let startDate = element.startDate {
                    var date = dateFormatter.string(from: startDate)
                    if let endDate = element.endDate {
                        date += "-\(dateFormatter.string(from: endDate))"
                    }
                    
                    result.append((date, .third))
                }
                
                return result
            }
            cell.setup(element: element)
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
extension CVMWETableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CVMWETableView {
    func initialize() {
        register(CVMakerTitleCell.self, forCellReuseIdentifier: String(describing: CVMakerTitleCell.self))
        register(CVMakerEntityCell<WorkExperience>.self, forCellReuseIdentifier: String(describing: CVMakerEntityCell<WorkExperience>.self))
        register(CVMakerAddCell.self, forCellReuseIdentifier: String(describing: CVMakerAddCell.self))
        
        dataSource = self
        delegate = self
    }
}
