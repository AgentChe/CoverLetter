//
//  CVMWECreateFieldsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 24.05.2024.
//

import UIKit

final class CVMWECreateFieldsView: UIView {
    lazy var jobTitleField = makeInputField(
        title: "CVMaker.WorkExperience.JobTitle.Title".localized, 
        placeholder: "CVMaker.WorkExperience.JobTitle.Placeholder".localized
    )
    lazy var companyNameField = makeInputField(
        title: "CVMaker.WorkExperience.CompanyName.Title".localized,
        placeholder: "CVMaker.WorkExperience.CompanyName.Placeholder".localized
    )
    lazy var startDateField = makeDateField(
        title: "CVMaker.WorkExperience.StartDate.Title".localized,
        placeholder: "CVMaker.WorkExperience.StartDate.Placeholder".localized
    )
    lazy var endDateField = makeDateField(
        title: "CVMaker.WorkExperience.EndDate.Title".localized,
        placeholder: "CVMaker.WorkExperience.EndDate.Placeholder".localized
    )
    lazy var resultsField = makeInputField(
        title: "CVMaker.WorkExperience.Results.Title".localized,
        placeholder: "CVMaker.WorkExperience.Results.Placeholder".localized
    )
    
    var didChangeCanComplete: ((Bool) -> Void)? {
        didSet {
            checkEnable()
        }
    }
    
    private let finish: (WorkExperience) -> Void
    
    init(finish: @escaping (WorkExperience) -> Void) {
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
extension CVMWECreateFieldsView {
    func setup(workExperience: WorkExperience?) {
        jobTitleField.textField.text = workExperience?.jobTitle
        companyNameField.textField.text = workExperience?.companyName
        startDateField.setup(date: workExperience?.startDate)
        endDateField.setup(date: workExperience?.endDate)
        resultsField.textField.text = workExperience?.results
    }
    
    var valid: Bool {
        let jobTitle = jobTitleField.textField.text ?? ""
        let companyName = companyNameField.textField.text ?? ""
        let startDate = startDateField.date
        let results = resultsField.textField.text ?? ""
        
        let empty = jobTitle.isEmpty || companyName.isEmpty || (startDate == nil) || results.isEmpty
        
        return !empty
    }
}

// MARK: WrappedView
extension CVMWECreateFieldsView: WrappedView {
    func complete() {
        let workExperience = WorkExperience(
            jobTitle: jobTitleField.textField.text,
            companyName: companyNameField.textField.text,
            startDate: startDateField.date,
            endDate: endDateField.date,
            results: resultsField.textField.text
        )
        finish(workExperience)
    }
}

// MARK: Private
private extension CVMWECreateFieldsView {
    func initialize() {
        jobTitleField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        companyNameField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        startDateField.editing = { [weak self] date in
            self?.checkEnable()
        }
        
        resultsField.editing = { [weak self] text in
            self?.checkEnable()
        }
    }
    
    func checkEnable() {
        didChangeCanComplete?(valid)
    }
}

// MARK: Make constraints
private extension CVMWECreateFieldsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            jobTitleField.leadingAnchor.constraint(equalTo: leadingAnchor),
            jobTitleField.trailingAnchor.constraint(equalTo: trailingAnchor),
            jobTitleField.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            companyNameField.leadingAnchor.constraint(equalTo: leadingAnchor),
            companyNameField.trailingAnchor.constraint(equalTo: trailingAnchor),
            companyNameField.topAnchor.constraint(equalTo: jobTitleField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            startDateField.leadingAnchor.constraint(equalTo: leadingAnchor),
            startDateField.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10.scale),
            startDateField.topAnchor.constraint(equalTo: companyNameField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            endDateField.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale),
            endDateField.trailingAnchor.constraint(equalTo: trailingAnchor),
            endDateField.topAnchor.constraint(equalTo: companyNameField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            resultsField.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsField.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsField.topAnchor.constraint(equalTo: companyNameField.bottomAnchor, constant: 117.scale),
            resultsField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMWECreateFieldsView {
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
