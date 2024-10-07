//
//  CVMRCreateFieldsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMRCreateFieldsView: UIView {
    lazy var nameField = makeInputField(
        title: "CVMaker.References.Name.Title".localized,
        placeholder: "CVMaker.References.Name.Placeholder".localized
    )
    lazy var jobTitleField = makeInputField(
        title: "CVMaker.References.JobTitle.Title".localized,
        placeholder: "CVMaker.References.JobTitle.Placeholder".localized
    )
    lazy var phoneField = makeInputField(
        title: "CVMaker.References.Phone.Title".localized,
        placeholder: "CVMaker.References.Phone.Placeholder".localized
    )
    lazy var emailField = makeInputField(
        title: "CVMaker.References.Email.Title".localized,
        placeholder: "CVMaker.References.Email.Placeholder".localized
    )
    
    var didChangeCanComplete: ((Bool) -> Void)? {
        didSet {
            checkEnable()
        }
    }
    
    private let finish: (Reference) -> Void
    
    init(finish: @escaping (Reference) -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        checkEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMRCreateFieldsView {
    func setup(reference: Reference?) {
        nameField.textField.text = reference?.name
        jobTitleField.textField.text = reference?.jobTitle
        phoneField.textField.text = reference?.phone
        emailField.textField.text = reference?.email
    }
    
    var valid: Bool {
        let name = nameField.textField.text ?? ""
        let jobTitle = jobTitleField.textField.text ?? ""
        let phone = phoneField.textField.text ?? ""
        let email = emailField.textField.text ?? ""
        
        let empty = name.isEmpty && jobTitle.isEmpty && phone.isEmpty && email.isEmpty
        
        return !empty
    }
}

// MARK: WrappedView
extension CVMRCreateFieldsView: WrappedView {
    func complete() {
        let reference = Reference(
            name: nameField.textField.text,
            jobTitle: jobTitleField.textField.text,
            phone: phoneField.textField.text,
            email: emailField.textField.text
        )
        finish(reference)
    }
}

// MARK: Private
private extension CVMRCreateFieldsView {
    func initialize() {
        nameField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        jobTitleField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        phoneField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        emailField.editing = { [weak self] text in
            self?.checkEnable()
        }
    }
    
    func checkEnable() {
        didChangeCanComplete?(valid)
    }
}

// MARK: Make constraints
private extension CVMRCreateFieldsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameField.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            jobTitleField.leadingAnchor.constraint(equalTo: leadingAnchor),
            jobTitleField.trailingAnchor.constraint(equalTo: trailingAnchor),
            jobTitleField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            phoneField.leadingAnchor.constraint(equalTo: leadingAnchor),
            phoneField.trailingAnchor.constraint(equalTo: trailingAnchor),
            phoneField.topAnchor.constraint(equalTo: jobTitleField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor),
            emailField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 20.scale),
            emailField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMRCreateFieldsView {
    func makeInputField(title: String, placeholder: String) -> InputField {
        let view = InputField(title: title.uppercased(), placeholder: placeholder)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
