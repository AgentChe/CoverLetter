//
//  CVMECreateFieldsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit

final class CVMECreateFieldsView: UIView {
    lazy var universityField = makeInputField(
        title: "CVMaker.Education.University.Title".localized,
        placeholder: "CVMaker.Education.University.Placeholder".localized
    )
    lazy var fieldStudyField = makeInputField(
        title: "CVMaker.Education.FieldStudy.Title".localized,
        placeholder: "CVMaker.Education.FieldStudy.Placeholder".localized
    )
    lazy var degreeField = makeInputField(
        title: "CVMaker.Education.Degree.Title".localized,
        placeholder: "CVMaker.Education.Degree.Placeholder".localized
    )
    lazy var startDateField = makeDateField(
        title: "CVMaker.Education.StartDate.Title".localized,
        placeholder: "CVMaker.Education.StartDate.Placeholder".localized
    )
    lazy var endDateField = makeDateField(
        title: "CVMaker.Education.EndDate.Title".localized,
        placeholder: "CVMaker.Education.EndDate.Placeholder".localized
    )
    
    var didChangeCanComplete: ((Bool) -> Void)? {
        didSet {
            checkEnable()
        }
    }
    
    private let finish: (Education) -> Void
    
    init(finish: @escaping (Education) -> Void) {
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
extension CVMECreateFieldsView {
    func setup(education: Education?) {
        universityField.textField.text = education?.university
        fieldStudyField.textField.text = education?.fieldOfStudy
        degreeField.textField.text = education?.degree
        startDateField.setup(date: education?.startDate)
        endDateField.setup(date: education?.endDate)
    }
    
    var valid: Bool {
        let university = universityField.textField.text ?? ""
        let fieldStudy = fieldStudyField.textField.text ?? ""
        let degree = degreeField.textField.text ?? ""
        let startDate = startDateField.date
        
        let empty = university.isEmpty || fieldStudy.isEmpty || degree.isEmpty || (startDate == nil)
        
        return !empty
    }
}

// MARK: WrappedView
extension CVMECreateFieldsView: WrappedView {
    func complete() {
        let education = Education(
            university: universityField.textField.text,
            fieldOfStudy: fieldStudyField.textField.text,
            degree: degreeField.textField.text,
            startDate: startDateField.date,
            endDate: endDateField.date
        )
        finish(education)
    }
}

// MARK: Private
private extension CVMECreateFieldsView {
    func initialize() {
        universityField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        fieldStudyField.editing = { [weak self] text in
            self?.checkEnable()
        }
        
        degreeField.editing = { [weak self] date in
            self?.checkEnable()
        }
        
        startDateField.editing = { [weak self] text in
            self?.checkEnable()
        }
    }
    
    func checkEnable() {
        didChangeCanComplete?(valid)
    }
}

// MARK: Make constraints
private extension CVMECreateFieldsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            universityField.leadingAnchor.constraint(equalTo: leadingAnchor),
            universityField.trailingAnchor.constraint(equalTo: trailingAnchor),
            universityField.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fieldStudyField.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldStudyField.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldStudyField.topAnchor.constraint(equalTo: universityField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            degreeField.leadingAnchor.constraint(equalTo: leadingAnchor),
            degreeField.trailingAnchor.constraint(equalTo: trailingAnchor),
            degreeField.topAnchor.constraint(equalTo: fieldStudyField.bottomAnchor, constant: 20.scale),
            degreeField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -97.scale)
        ])
        
        NSLayoutConstraint.activate([
            startDateField.leadingAnchor.constraint(equalTo: leadingAnchor),
            startDateField.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10.scale),
            startDateField.topAnchor.constraint(equalTo: degreeField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            endDateField.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale),
            endDateField.trailingAnchor.constraint(equalTo: trailingAnchor),
            endDateField.topAnchor.constraint(equalTo: degreeField.bottomAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMECreateFieldsView {
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
