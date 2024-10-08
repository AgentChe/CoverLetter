//
//  CLMakerHMGenderView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

protocol CLMakerHMGenderViewDelegate: AnyObject {
    func genderView(gender: CLHiringManager.Gender?)
}

final class CLMakerHMGenderView: CLMakerHiringManagerStepView {
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeTitleLabel()
    lazy var femaleButton = makeGenderButton(gender: .female)
    lazy var maleButton = makeGenderButton(gender: .male)
    lazy var continueButton = makeContinueButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private weak var mainDelegate: CLMakerHMGenderViewDelegate?
    
    init(mainDelegate: CLMakerHMGenderViewDelegate) {
        self.mainDelegate = mainDelegate
        
        super.init(step: .gender)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerHMGenderView {
    func setup(gender: CLHiringManager.Gender?) {
        femaleButton.marked = gender == .female
        maleButton.marked = gender == .male
    }
}

// MARK: Private
private extension CLMakerHMGenderView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        Signal<CLHiringManager.Gender>
            .merge(
                femaleButton.rx.tap.map { CLHiringManager.Gender.female }.asSignal(onErrorSignalWith: .never()),
                maleButton.rx.tap.map { CLHiringManager.Gender.male }.asSignal(onErrorSignalWith: .never())
            )
            .emit(to: Binder(self) { base, gender in
                base.setup(gender: gender)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func continueTapped() {
        let gender = [
            (CLHiringManager.Gender.female, femaleButton),
            (CLHiringManager.Gender.male, maleButton)
        ].first(where: { $1.marked })?.0
        
        mainDelegate?.genderView(gender: gender)
        
        onNext()
    }
}

// MARK: Make constraints
private extension CLMakerHMGenderView {
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
            femaleButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            femaleButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            femaleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            maleButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            maleButton.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 24.scale),
            maleButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            maleButton.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -8.scale : -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerHMGenderView {
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
        view.attributedText = "CLMaker.HiringManager.WhoIs.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeGenderButton(gender: CLHiringManager.Gender) -> CLMHRGenderButton {
        let view = CLMHRGenderButton(gender: gender)
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
