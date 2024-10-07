//
//  OStepsView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import UIKit

final class OStepsView: UIView {
    lazy var welcomeDivisionView = makeDivisionView()
    lazy var inputInfoDivisionView = makeDivisionView()
    lazy var finalizeDivisionView = makeDivisionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OStepsView {
    func update(at step: OnboardingView.Step) {
        welcomeDivisionView.alpha = step.equalOrGreater(than: .welcome) ? 1 : 0.2
        inputInfoDivisionView.alpha = step.equalOrGreater(than: .inputInfo) ? 1 : 0.2
        finalizeDivisionView.alpha = step.equalOrGreater(than: .finalize) ? 1 : 0.2
    }
}

// MARK: Private
private extension OStepsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension OStepsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            welcomeDivisionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            welcomeDivisionView.widthAnchor.constraint(equalToConstant: 107.scale),
            welcomeDivisionView.heightAnchor.constraint(equalToConstant: 4.scale),
            welcomeDivisionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            inputInfoDivisionView.leadingAnchor.constraint(equalTo: welcomeDivisionView.trailingAnchor, constant: 8.scale),
            inputInfoDivisionView.widthAnchor.constraint(equalToConstant: 107.scale),
            inputInfoDivisionView.heightAnchor.constraint(equalToConstant: 4.scale),
            inputInfoDivisionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            finalizeDivisionView.leadingAnchor.constraint(equalTo: inputInfoDivisionView.trailingAnchor, constant: 8.scale),
            finalizeDivisionView.widthAnchor.constraint(equalToConstant: 107.scale),
            finalizeDivisionView.heightAnchor.constraint(equalToConstant: 4.scale),
            finalizeDivisionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OStepsView {
    func makeDivisionView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom_35_22_00
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension OnboardingView.Step {
    func equalOrGreater(than step: OnboardingView.Step) -> Bool {
        rawValue >= step.rawValue
    }
}
