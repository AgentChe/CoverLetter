//
//  CLsGroupsView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class CLsGroupsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var emptyView = makeEmptyView()
    lazy var tableView = makeTableView()
    lazy var createNewButton = makeCreateNewButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CLsGroupsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CLsGroupsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 71.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: createNewButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            createNewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            createNewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            createNewButton.heightAnchor.constraint(equalToConstant: 58.scale),
            createNewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLsGroupsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 32.scale))
            .lineHeight(39.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CLsGroups.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> CLsGroupsEmptyView {
        let view = CLsGroupsEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> CLsGroupsTableView {
        let view = CLsGroupsTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateNewButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_fdfdfd)
            .font(Fonts.Inter.semibold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CLsGroups.CreateNew".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.custom_ed6f00
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
