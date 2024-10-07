//
//  CLMakerChapterButton.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit

final class CLMakerChapterButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    lazy var divider = makeDivider()
    
    let chapter: CLMakerOnboardingView.Chapter
    
    init(chapter: CLMakerOnboardingView.Chapter) {
        self.chapter = chapter
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CLMakerChapterButton {
    func update() {
        alpha = marked ? 1 : 0.3
        divider.isHidden = !marked
    }
}

// MARK: Make constraints
private extension CLMakerChapterButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerChapterButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = chapter.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CLMakerOnboardingView.Chapter {
    var title: String {
        switch self {
        case .personalInfo:
            return "CLMaker.Chapter.PersonalInfo".localized
        case .companyInfo:
            return "CLMaker.Chapter.CompanyInfo".localized
        case .hiringManager:
            return "CLMaker.Chapter.HiringManager".localized
        case .vacancy:
            return "CLMaker.Chapter.Vacancy".localized
        case .toneOnVoice:
            return "CLMaker.Chapter.ToneOfVoice".localized
        }
    }
}
