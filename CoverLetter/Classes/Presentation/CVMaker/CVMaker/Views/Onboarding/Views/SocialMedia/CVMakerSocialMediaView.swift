//
//  CVMakerSocialMediaView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit
import RxSwift

final class CVMakerSocialMediaView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var instagramField = makeInputField(
        title: "CVMaker.SocialMedia.Instagram".localized,
        placeholder: "CVMaker.SocialMedia.Link".localized
    )
    lazy var facebookField = makeInputField(
        title: "CVMaker.SocialMedia.Facebook".localized,
        placeholder: "CVMaker.SocialMedia.Link".localized
    )
    lazy var linkedinField = makeInputField(
        title: "CVMaker.SocialMedia.Linkedin".localized,
        placeholder: "CVMaker.SocialMedia.Link".localized
    )
    lazy var twitterField = makeInputField(
        title: "CVMaker.SocialMedia.Twitter".localized,
        placeholder: "CVMaker.SocialMedia.Link".localized
    )
    lazy var continueButton = makeContinueButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var continueBottomConstraint = NSLayoutConstraint()
    
    private let bind: (SocialMedia) -> Void
    private let flowFinished: (() -> Void)
    
    init(
        bind: @escaping (SocialMedia) -> Void,
        flowFinished: @escaping (() -> Void)
    ) {
        self.bind = bind
        self.flowFinished = flowFinished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerSocialMediaView {
    func setup(socialMedia: SocialMedia?) {
        instagramField.textField.text = socialMedia?.instagram
        facebookField.textField.text = socialMedia?.facebook
        linkedinField.textField.text = socialMedia?.linkedIn
        twitterField.textField.text = socialMedia?.twitter
    }
}

// MARK: Private
private extension CVMakerSocialMediaView {
    func initialize() {
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
        let socialMedia = SocialMedia(
            instagram: instagramField.textField.text,
            facebook: facebookField.textField.text,
            linkedIn: linkedinField.textField.text,
            twitter: twitterField.textField.text
        )
        bind(socialMedia)
        
        flowFinished()
    }
}

// MARK: Make constraints
private extension CVMakerSocialMediaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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
            instagramField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            instagramField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            instagramField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            facebookField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            facebookField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            facebookField.topAnchor.constraint(equalTo: instagramField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            linkedinField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            linkedinField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            linkedinField.topAnchor.constraint(equalTo: facebookField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            twitterField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            twitterField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            twitterField.topAnchor.constraint(equalTo: linkedinField.bottomAnchor, constant: 20.scale),
            twitterField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
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
private extension CVMakerSocialMediaView {
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
        view.attributedText = "CVMaker.SocialMedia.Title".localized.attributed(with: attrs)
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
        view.attributedText = "CVMaker.SocialMedia.SubTitle".localized.attributed(with: attrs)
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
