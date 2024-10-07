//
//  CVMakerGeneralInfoContactInfoView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit
import RxSwift

protocol CVMakerGeneralInfoContactInfoViewDelegate: AnyObject {
    func generalInfo(contactInfo: ContactInfo)
}

final class CVMakerGeneralInfoContactInfoView: CVMakerGeneralInfoFlowView {
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var phoneField = makeInputField(
        title: "CVMaker.ContactInfo.Phone.Title".localized,
        placeholder: "CVMaker.ContactInfo.Phone.Placeholder".localized
    )
    lazy var emailField = makeInputField(
        title: "CVMaker.ContactInfo.Email.Title".localized,
        placeholder: "CVMaker.ContactInfo.Email.Placeholder".localized
    )
    lazy var websiteField = makeInputField(
        title: "CVMaker.ContactInfo.Website.Title".localized,
        placeholder: "CVMaker.ContactInfo.Website.Placeholder".localized
    )
    lazy var homeAddressField = makeHomeAddressField()
    lazy var continueButton = makeContinueButton()
    
    private lazy var selectCityAssemby = SelectCityAssemby()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var continueBottomConstraint = NSLayoutConstraint()
    
    private weak var vc: UIViewController?
    private weak var mainDelegate: CVMakerGeneralInfoContactInfoViewDelegate?
    
    init(vc: UIViewController?, mainDelegate: CVMakerGeneralInfoContactInfoViewDelegate?) {
        self.vc = vc
        self.mainDelegate = mainDelegate
        
        super.init(step: .contactInfo)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerGeneralInfoContactInfoView {
    func setup(contactInfo: ContactInfo?) {
        phoneField.textField.text = contactInfo?.phone
        emailField.textField.text = contactInfo?.email
        websiteField.textField.text = contactInfo?.website
        homeAddressField.value = contactInfo?.homeAddress
    }
}

// MARK: Private
private extension CVMakerGeneralInfoContactInfoView {
    func initialize() {
        rx.keyboardHeight
            .bind(to: Binder(self) { base, keyboardHeight in
                base.continueBottomConstraint.isActive = false
                base.continueBottomConstraint.constant = -(keyboardHeight + 16.scale)
                base.continueBottomConstraint.isActive = true
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
        
        homeAddressField.action = { [weak self] in
            guard let self, let vc else { return }
            
            selectCityAssemby.startFlow(from: vc) { [weak self] result in
                self?.homeAddressField.value = String(format: "%@, %@", result.country.name, result.city)
            }
        }
        
        phoneField.textField.keyboardType = .phonePad
        emailField.textField.keyboardType = .emailAddress
    }
    
    @objc
    func continueTapped() {
        [
            phoneField.textField,
            emailField.textField,
            websiteField.textField,
        ].forEach { $0.resignFirstResponder() }
        
        let contactInfo = ContactInfo(
            phone: phoneField.textField.text,
            email: emailField.textField.text,
            website: websiteField.textField.text,
            homeAddress: homeAddressField.value
        )
        mainDelegate?.generalInfo(contactInfo: contactInfo)
        
        onNext()
    }
}

// MARK: Make constraints
private extension CVMakerGeneralInfoContactInfoView {
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
            phoneField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            phoneField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            phoneField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            emailField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            emailField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            websiteField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            websiteField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            websiteField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            homeAddressField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            homeAddressField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            homeAddressField.topAnchor.constraint(equalTo: websiteField.bottomAnchor, constant: 20.scale),
            homeAddressField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
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
private extension CVMakerGeneralInfoContactInfoView {
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
            .font(Fonts.SFPro.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CVMaker.ContactInfo.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CVMaker.ContactInfo.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeInputField(title: String, placeholder: String) -> InputField {
        let view = InputField(title: title.uppercased(), placeholder: placeholder)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeHomeAddressField() -> SelectField {
        let view = SelectField(
            title: "CVMaker.ContactInfo.HomeAddress.Title".localized.uppercased(),
            placeholder: "CVMaker.ContactInfo.HomeAddress.Placeholder".localized
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = Appearance.main200
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
