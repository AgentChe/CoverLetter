//
//  CLMakerVacancyPositionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit
import RxSwift

protocol CLMakerVacancyPositionViewDelegate: AnyObject {
    func position(link: String?, position: String?, description: String?)
}

final class CLMakerVacancyPositionView: CLMakerVacancyStepView {
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var linkField = makeLinkField()
    lazy var positionField = makePositionField()
    lazy var descriptionField = makeDescriptionField()
    lazy var continueButton = makeContinueButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var continueBottomConstraint = NSLayoutConstraint()
    
    private weak var mainDelegate: CLMakerVacancyPositionViewDelegate?
    
    init(mainDelegate: CLMakerVacancyPositionViewDelegate?) {
        self.mainDelegate = mainDelegate
        
        super.init(step: .position)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerVacancyPositionView {
    func setup(position: String?) {
        positionField.textField.text = position
    }
}

// MARK: Private
private extension CLMakerVacancyPositionView {
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
        positionField.resignFirstResponder()
        
        mainDelegate?.position(
            link: linkField.textField.text,
            position: positionField.textField.text,
            description: descriptionField.textField.text
        )
        
        onNext()
    }
}

// MARK: Make constraints
private extension CLMakerVacancyPositionView {
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
            linkField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            linkField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            linkField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            positionField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            positionField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            positionField.topAnchor.constraint(equalTo: linkField.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            descriptionField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            descriptionField.topAnchor.constraint(equalTo: positionField.bottomAnchor, constant: 28.scale),
            descriptionField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -28.scale)
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
private extension CLMakerVacancyPositionView {
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
        view.attributedText = "CLMaker.Vacancy.Position.Title".localized.attributed(with: attrs)
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
        view.attributedText = "CLMaker.Vacancy.Position.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeLinkField() -> InputField {
        let view = InputField(
            title: "CLMaker.Vacancy.Link.Title".localized.uppercased(),
            placeholder: "CLMaker.Vacancy.Link.Placeholder".localized
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makePositionField() -> InputField {
        let view = InputField(
            title: "CLMaker.Vacancy.Position.Field.Title".localized,
            placeholder: "CLMaker.Vacancy.Position.Field.Placeholder".localized
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeDescriptionField() -> InputField {
        let view = InputField(
            title: "CLMaker.Vacancy.Description.Title".localized.uppercased(),
            placeholder: "CLMaker.Vacancy.Description.Placeholder".localized
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
