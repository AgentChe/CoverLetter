//
//  CLMTBTableCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

final class CLMTBTableCell: UITableViewCell {
    lazy var nameLabel = makeNameLabel()
    lazy var textView = makeTextView()
    
    private var element: CLMTBTableTextBlockElement?
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.custom_1e2340.withAlphaComponent(0.4))
        .font(Fonts.Inter.semibold(size: 10.scale))
        .lineHeight(14.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMTBTableCell {
    func setup(element: CLMTBTableTextBlockElement) {
        self.element = element
        
        nameLabel.attributedText = element.name?.attributed(with: nameAttrs)
        textView.text = element.content
    }
}

// MARK: UITextViewDelegate
extension CLMTBTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let element else { return }
        
        element.content = textView.text
    }
}

// MARK: Private
private extension CLMTBTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CLMTBTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.scale),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 116.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMTBTableCell {
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextView() -> UITextView {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.Inter.regular(size: 17.scale))
            .lineHeight(23.scale)
            .textAlignment(.left)
        
        let view = UITextView()
        view.textContainerInset = UIEdgeInsets(vertical: 18.scale, horizontal: 16.scale)
        view.typingAttributes = attrs.dictionary
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
