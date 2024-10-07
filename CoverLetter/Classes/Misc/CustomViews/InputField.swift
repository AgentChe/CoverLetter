//
//  InputField.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class InputField: UIView {
    var editing: ((String) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    
    private let title: String
    private let placeholder: String
    
    init(title: String, placeholder: String? = nil) {
        self.title = title
        self.placeholder = placeholder ?? title
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension InputField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension InputField {
    @objc
    func editingChanged() {
        editing?(textField.text ?? "")
    }
}

// MARK: Make constraints
private extension InputField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension InputField {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Nunito.semiBold(size: 10.scale))
            .lineHeight(13.64.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Nunito.semiBold(size: 17.scale))
            .lineHeight(23.19.scale)
            .textAlignment(.left)
        let textAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
            .lineHeight(23.19.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(vertical: 18.scale, horizontal: 16.scale)
        view.layer.cornerRadius = 10.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.delegate = self
        view.defaultTextAttributes = textAttrs.dictionary
        view.attributedPlaceholder = placeholder.attributed(with: placeholderAttrs)
        view.borderStyle = .none
        view.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
