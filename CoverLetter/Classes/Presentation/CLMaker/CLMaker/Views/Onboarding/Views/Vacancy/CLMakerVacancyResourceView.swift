//
//  CLMakerVacancyResourceView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit
import RxSwift

protocol CLMakerVacancyResourceViewDelegate: AnyObject {
    func resource(_ resource: String?)
}

final class CLMakerVacancyResourceView: CLMakerVacancyStepView {
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var resourceField = makeInputField()
    lazy var continueButton = makeContinueButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var continueBottomConstraint = NSLayoutConstraint()
    
    private weak var mainDelegate: CLMakerVacancyResourceViewDelegate?
    
    init(mainDelegate: CLMakerVacancyResourceViewDelegate?) {
        self.mainDelegate = mainDelegate
        
        super.init(step: .resource)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerVacancyResourceView {
    func setup(resource: String?) {
        resourceField.textField.text = resource
    }
}

// MARK: Private
private extension CLMakerVacancyResourceView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        rx.keyboardHeight
            .bind(to: Binder(self) { base, keyboardHeight in
                base.continueBottomConstraint.isActive = false
                base.continueBottomConstraint.constant = -(keyboardHeight + 8.scale)
                base.continueBottomConstraint.isActive = true
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func continueTapped() {
        resourceField.resignFirstResponder()
        
        mainDelegate?.resource(resourceField.textField.text)
        
        onNext()
    }
}

// MARK: Make constraints
private extension CLMakerVacancyResourceView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            resourceField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            resourceField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            resourceField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 28.scale),
            resourceField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        continueBottomConstraint = continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -8.scale : -16.scale)
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueBottomConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerVacancyResourceView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CLMaker.Vacancy.Resource.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CLMaker.Vacancy.Resource.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeInputField() -> InputField {
        let view = InputField(
            title: "CLMaker.Vacancy.Resource.Field.Title".localized, 
            placeholder: "CLMaker.Vacancy.Resource.Field.Placeholder".localized
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semibold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.custom_ed6f00
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
