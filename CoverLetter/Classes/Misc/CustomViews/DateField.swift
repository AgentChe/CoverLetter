//
//  DateField.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 24.05.2024.
//

import UIKit

final class DateField: UIView {
    var editing: ((Date?) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    lazy var calendarIconView = makeCalendarIconView()
    lazy var datePicker = makeDatePicker()
    
    private(set) var date: Date?
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    private let title: String
    private let placeholder: String
    private let dateFormat: String
    
    init(title: String, placeholder: String? = nil, dateFormat: String = "MM.yyyy") {
        self.title = title
        self.placeholder = placeholder ?? title
        self.dateFormat = dateFormat
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension DateField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Public
extension DateField {
    func setup(date: Date?, willCallback: Bool = false) {
        self.date = date
        
        let formatted: String = {
            guard let date else {
                return placeholder
            }
            
            return formatter.string(from: date)
        }()
        textField.text = formatted
        
        if willCallback {
            editing?(date)
        }
    }
}

// MARK: Private
private extension DateField {
    @objc
    func pressDoneButton() {
        textField.resignFirstResponder()
        setup(date: datePicker.date, willCallback: true)
    }
}

// MARK: Make constraints
private extension DateField {
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
        
        NSLayoutConstraint.activate([
            calendarIconView.widthAnchor.constraint(equalToConstant: 19.scale),
            calendarIconView.heightAnchor.constraint(equalToConstant: 18.scale),
            calendarIconView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -16.scale),
            calendarIconView.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DateField {
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
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pressDoneButton))
        
        let toolBar = UIToolbar()
        toolBar.setItems([doneBtn], animated: false)
        toolBar.sizeToFit()
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(t: 18.scale, l: 16.scale, b: 18.scale, r: 42.scale)
        view.inputAccessoryView = toolBar
        view.inputView = datePicker
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCalendarIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = UIImage(named: "Calendar")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(view)
        return view
    }
    
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.preferredDatePickerStyle = .wheels
        view.datePickerMode = .date
        return view
    }
}
