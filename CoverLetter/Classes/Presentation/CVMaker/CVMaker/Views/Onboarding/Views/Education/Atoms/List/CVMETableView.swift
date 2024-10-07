//
//  CVMETableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit

final class CVMETableView: UITableView {
    var didDelete: ((Education) -> Void)?
    var didAddMore: (() -> Void)?
    
    lazy var elements = [CVMETableElement]()
    
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
extension CVMETableView {
    func setup(elements: [CVMETableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CVMETableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .title:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerTitleCell.self), for: indexPath) as! CVMakerTitleCell
            cell.setup(title: "CVMaker.Education.ListTitle".localized)
            return cell
        case .education(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerEntityCell<Education>.self), for: indexPath) as! CVMakerEntityCell<Education>
            cell.map = { [weak self] education -> [(String, CVMakerEntityCell<Education>.TextAttrs)] in
                guard let self else { return [] }
                
                var result = [(String, CVMakerEntityCell<Education>.TextAttrs)]()
                
                if let fieldOfStudy = education.fieldOfStudy {
                    result.append((fieldOfStudy, .first))
                }
                
                if let degree = element.degree {
                    result.append((degree, .second))
                }
                
                let date: String? = {
                    guard let startDate = education.startDate else {
                        return nil
                    }
                    
                    var date = self.dateFormatter.string(from: startDate)
                    if let endDate = element.endDate {
                        date += "-\(self.dateFormatter.string(from: endDate))"
                    }
                    return date
                }()
                
                let third: String? = {
                    let result = [education.university, date]
                        .compactMap { $0 }
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                    return result.isEmpty ? nil : result
                }()
                if let third {
                    result.append((third, .third))
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
extension CVMETableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CVMETableView {
    func initialize() {
        register(CVMakerTitleCell.self, forCellReuseIdentifier: String(describing: CVMakerTitleCell.self))
        register(CVMakerEntityCell<Education>.self, forCellReuseIdentifier: String(describing: CVMakerEntityCell<Education>.self))
        register(CVMakerAddCell.self, forCellReuseIdentifier: String(describing: CVMakerAddCell.self))
        
        dataSource = self
        delegate = self
    }
}
