//
//  CVMakerChaptersView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit

final class CVMakerChaptersView: UIView {
    var didSelect: ((CVMakerOnboardingView.Chapter) -> Void)?
    
    lazy var scrollView = makeScrollView()
    lazy var generalInfoButton = makeChapterButton(chapter: .generalInfo)
    lazy var workExperienceButton = makeChapterButton(chapter: .workExperience)
    lazy var educationButton = makeChapterButton(chapter: .education)
    lazy var professionalSkillsButton = makeChapterButton(chapter: .professionalSkills)
    lazy var languagesButton = makeChapterButton(chapter: .languages)
    lazy var interestsButton = makeChapterButton(chapter: .interests)
    lazy var certificatesButton = makeChapterButton(chapter: .certificates)
    lazy var socialMediaButton = makeChapterButton(chapter: .socialMedia)
    lazy var referencesButton = makeChapterButton(chapter: .references)
    
    private lazy var buttons = [
        generalInfoButton,
        workExperienceButton,
        educationButton,
        professionalSkillsButton,
        languagesButton,
        interestsButton,
        certificatesButton,
        socialMediaButton,
        referencesButton
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerChaptersView {
    func setup(chapter: CVMakerOnboardingView.Chapter, withCallback: Bool = false) {
        buttons.forEach { $0.marked = $0.chapter == chapter }
        
        if withCallback {
            didSelect?(chapter)
        }
    }
}

// MARK: Private
private extension CVMakerChaptersView {
    @objc
    func tapped(sender: UIButton) {
        guard let chapterButton = sender as? CVMakerChapterButton else {
            return
        }
        
        buttons.forEach { $0.marked = $0.chapter == chapterButton.chapter }
        
        didSelect?(chapterButton.chapter)
    }
}

// MARK: Make constraints
private extension CVMakerChaptersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            generalInfoButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            generalInfoButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            generalInfoButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            generalInfoButton.topAnchor.constraint(equalTo: topAnchor),
            generalInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            workExperienceButton.leadingAnchor.constraint(equalTo: generalInfoButton.trailingAnchor, constant: 16.scale),
            workExperienceButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            workExperienceButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            educationButton.leadingAnchor.constraint(equalTo: workExperienceButton.trailingAnchor, constant: 16.scale),
            educationButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            educationButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            professionalSkillsButton.leadingAnchor.constraint(equalTo: educationButton.trailingAnchor, constant: 16.scale),
            professionalSkillsButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            professionalSkillsButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            languagesButton.leadingAnchor.constraint(equalTo: professionalSkillsButton.trailingAnchor, constant: 16.scale),
            languagesButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            languagesButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            interestsButton.leadingAnchor.constraint(equalTo: languagesButton.trailingAnchor, constant: 16.scale),
            interestsButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            interestsButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            certificatesButton.leadingAnchor.constraint(equalTo: interestsButton.trailingAnchor, constant: 16.scale),
            certificatesButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            certificatesButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            socialMediaButton.leadingAnchor.constraint(equalTo: certificatesButton.trailingAnchor, constant: 16.scale),
            socialMediaButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            socialMediaButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            referencesButton.leadingAnchor.constraint(equalTo: socialMediaButton.trailingAnchor, constant: 16.scale),
            referencesButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            referencesButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            referencesButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerChaptersView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChapterButton(chapter: CVMakerOnboardingView.Chapter) -> CVMakerChapterButton {
        let view = CVMakerChapterButton(chapter: chapter)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        scrollView.addSubview(view)
        return view
    }
}
