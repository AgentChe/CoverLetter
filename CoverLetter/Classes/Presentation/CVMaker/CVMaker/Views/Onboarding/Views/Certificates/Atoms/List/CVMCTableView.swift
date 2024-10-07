//
//  CVMCTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMCTableView: UITableView {
    var didDelete: ((Certificate) -> Void)?
    var didAddMore: (() -> Void)?
    
    lazy var elements = [CVMCTableElement]()
    
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
extension CVMCTableView {
    func setup(elements: [CVMCTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CVMCTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .title:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerTitleCell.self), for: indexPath) as! CVMakerTitleCell
            cell.setup(title: "CVMaker.Certificates.List.Title".localized)
            return cell
        case .certificate(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CVMakerEntityCell<Certificate>.self), for: indexPath) as! CVMakerEntityCell<Certificate>
            cell.map = { [weak self] certificate -> [(String, CVMakerEntityCell<Certificate>.TextAttrs)] in
                guard let self else { return [] }
                
                var result = [(String, CVMakerEntityCell<Certificate>.TextAttrs)]()
                
                if let name = certificate.organizationName {
                    result.append((name, .first))
                }
                
                let date: String? = {
                    guard let startDate = certificate.startDate else {
                        return nil
                    }
                    
                    var date = self.dateFormatter.string(from: startDate)
                    if let endDate = certificate.endDate {
                        date += "-\(self.dateFormatter.string(from: endDate))"
                    }
                    return date
                }()
                if let date {
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
extension CVMCTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CVMCTableView {
    func initialize() {
        register(CVMakerTitleCell.self, forCellReuseIdentifier: String(describing: CVMakerTitleCell.self))
        register(CVMakerEntityCell<Certificate>.self, forCellReuseIdentifier: String(describing: CVMakerEntityCell<Certificate>.self))
        register(CVMakerAddCell.self, forCellReuseIdentifier: String(describing: CVMakerAddCell.self))
        
        dataSource = self
        delegate = self
    }
}
