//
//  CVMCCreateFieldsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMCCreateFieldsView: UIView {
    lazy var organizationNameField = makeInputField(
        title: "CVMaker.Certificates.OgranizationName.Title".localized,
        placeholder: "CVMaker.Certificates.OgranizationName.Placeholder".localized
    )
    lazy var startDateField = makeDateField(
        title: "CVMaker.Certificates.StartDate.Title".localized,
        placeholder: "CVMaker.Certificates.StartDate.Placeholder".localized
    )
    lazy var endDateField = makeDateField(
        title: "CVMaker.Certificates.EndDate.Title".localized,
        placeholder: "CVMaker.Certificates.EndDate.Placeholder".localized
    )
    lazy var shortDescriptionField = makeInputField(
        title: "CVMaker.Certificates.ShortDescription.Title".localized,
        placeholder: "CVMaker.Certificates.ShortDescription.Placeholder".localized
    )
    
    var didChangeCanComplete: ((Bool) -> Void)? {
        didSet {
            checkEnable()
        }
    }
    
    private let finish: (Certificate) -> Void
    
    init(finish: @escaping (Certificate) -> Void) {
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
extension CVMCCreateFieldsView {
    func setup(certificate: Certificate?) {
        organizationNameField.textField.text = certificate?.organizationName
        startDateField.setup(date: certificate?.startDate)
        endDateField.setup(date: certificate?.endDate)
        shortDescriptionField.textField.text = certificate?.description
    }
    
    var valid: Bool {
        let organizationName = organizationNameField.textField.text ?? ""
        let startDate = startDateField.date
        let endDate = endDateField.date
        let shortDescription = shortDescriptionField.textField.text ?? ""
        
        let empty = organizationName.isEmpty || (startDate == nil) || (endDate == nil) || shortDescription.isEmpty
        
        return !empty
    }
}

// MARK: WrappedView
extension CVMCCreateFieldsView: WrappedView {
    func complete() {
        let certificate = Certificate(
            organizationName: organizationNameField.textField.text,
            startDate: startDateField.date,
            endDate: endDateField.date,
            description: shortDescriptionField.textField.text
        )
        finish(certificate)
    }
}

// MARK: Private
private extension CVMCCreateFieldsView {
    func initialize() {
        organizationNameField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        startDateField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        endDateField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        shortDescriptionField.editing = { [weak self] text in
            self?.checkEnable()
        }
    }
    
    func checkEnable() {
        didChangeCanComplete?(valid)
    }
}

// MARK: Make constraints
private extension CVMCCreateFieldsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            organizationNameField.leadingAnchor.constraint(equalTo: leadingAnchor),
            organizationNameField.trailingAnchor.constraint(equalTo: trailingAnchor),
            organizationNameField.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startDateField.leadingAnchor.constraint(equalTo: leadingAnchor),
            startDateField.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10.scale),
            startDateField.topAnchor.constraint(equalTo: organizationNameField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            endDateField.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale),
            endDateField.trailingAnchor.constraint(equalTo: trailingAnchor),
            endDateField.topAnchor.constraint(equalTo: organizationNameField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            shortDescriptionField.leadingAnchor.constraint(equalTo: leadingAnchor),
            shortDescriptionField.trailingAnchor.constraint(equalTo: trailingAnchor),
            shortDescriptionField.topAnchor.constraint(equalTo: organizationNameField.bottomAnchor, constant: 117.scale),
            shortDescriptionField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMCCreateFieldsView {
    func makeInputField(title: String, placeholder: String) -> InputField {
        let view = InputField(title: title.uppercased(), placeholder: placeholder)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDateField(title: String, placeholder: String) -> DateField {
        let view = DateField(title: title.uppercased(), placeholder: placeholder)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
