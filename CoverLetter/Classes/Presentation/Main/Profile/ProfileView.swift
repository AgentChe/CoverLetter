//
//  ProfileView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit

final class ProfileView: UIView {
    lazy var tableView = makeTableView()
    
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
private extension ProfileView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension ProfileView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileView {
    func makeTableView() -> ProfileTableView {
        let view = ProfileTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(vertical: 29.scale)
        view.setContentOffset(CGPoint(x: 0, y: -29.scale), animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
