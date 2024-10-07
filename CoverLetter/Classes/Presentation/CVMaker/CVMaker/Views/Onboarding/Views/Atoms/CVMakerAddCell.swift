//
//  CVMakerAddCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit

final class CVMakerAddCell: UITableViewCell {
    var didTap: (() -> Void)?
    
    lazy var button = makeButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CVMakerAddCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tapped() {
        didTap?()
    }
}

// MARK: Make constraints
private extension CVMakerAddCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.scale),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerAddCell {
    func makeButton() -> DottedButton {
        let view = DottedButton()
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
