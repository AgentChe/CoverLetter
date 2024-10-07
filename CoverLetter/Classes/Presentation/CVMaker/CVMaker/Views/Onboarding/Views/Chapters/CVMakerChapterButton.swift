//
//  CVMakerChapterButton.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit

final class CVMakerChapterButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    lazy var divider = makeDivider()
    
    let chapter: CVMakerOnboardingView.Chapter
    
    init(chapter: CVMakerOnboardingView.Chapter) {
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
private extension CVMakerChapterButton {
    func update() {
        alpha = marked ? 1 : 0.3
        divider.isHidden = !marked
    }
}

// MARK: Make constraints
private extension CVMakerChapterButton {
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
private extension CVMakerChapterButton {
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
private extension CVMakerOnboardingView.Chapter {
    var title: String {
        switch self {
        case .generalInfo:
            return "CVMaker.Chapter.GeneralInfo".localized
        case .workExperience:
            return "CVMaker.Chapter.WorkExperience".localized
        case .education:
            return "CVMaker.Chapter.Education".localized
        case .professionalSkills:
            return "CVMaker.Chapter.ProfessionalSkills".localized
        case .languages:
            return "CVMaker.Chapter.Languages".localized
        case .interests:
            return "CVMaker.Chapter.Interests".localized
        case .certificates:
            return "CVMaker.Chapter.Certificates".localized
        case .socialMedia:
            return "CVMaker.Chapter.SocialMedia".localized
        case .references:
            return "CVMaker.Chapter.References".localized
        }
    }
}
