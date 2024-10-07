//
//  CVMakerOnboardingView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CVMakerOnboardingView: CVMakerFlowView {
    enum Chapter: Int {
        case generalInfo
        case workExperience
        case education
        case professionalSkills
        case languages
        case interests
        case certificates
        case socialMedia
        case references
    }
    
    lazy var chaptersView = makeChaptersView()
    lazy var container = makeContainer()
    lazy var chaptersViews: [Chapter: UIView] = [
        .generalInfo: generalInfoView,
        .workExperience: workExperienceView,
        .education: educationsView,
        .professionalSkills: professionalSkillsView,
        .languages: languagesView,
        .interests: interestsView,
        .certificates: certificatesView,
        .socialMedia: socialMediaView,
        .references: referencesView
    ]
    lazy var generalInfoView = CVMakerGeneralInfoView(vc: vc) { [weak self] generalInfo in
        self?.didCollectedGeneralInfoTrigger.accept(generalInfo)
        self?.next(chapter: .workExperience)
    }
    lazy var workExperienceView = CVMakerWorkExperienceView(vc: vc, bind: { [weak self] workExperiences in
        self?.didCollectedWorkExperienceTrigger.accept(workExperiences)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .education)
    })
    lazy var educationsView = CVMakerEducationView(vc: vc, bind: { [weak self] educations in
        self?.didCollectedEducationsTrigger.accept(educations)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .professionalSkills)
    })
    lazy var professionalSkillsView = CVMakerProfessionalSkillsView(vc: vc, bind: { [weak self] skills in
        self?.didCollectedProfessionalSkillsTrigger.accept(skills)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .languages)
    })
    lazy var languagesView = CVMakerLanguagesView(vc: vc, bind: { [weak self] languages in
        self?.didCollectedLanguagesTrigger.accept(languages)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .interests)
    })
    lazy var interestsView = CVMakerInterestsView(bind: { [weak self] interests in
        self?.didCollectedInterestsTrigger.accept(interests)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .certificates)
    })
    lazy var certificatesView = CVMakerCertificatesView(vc: vc, bind: { [weak self] certificates in
        self?.didCollectedCertificatesTrigger.accept(certificates)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .socialMedia)
    })
    lazy var socialMediaView = CVMakerSocialMediaView(bind: { [weak self] socialMedia in
        self?.didCollectedSocialMediaTrigger.accept(socialMedia)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .references)
    })
    lazy var referencesView = CVMakerReferencesView(vc: vc, bind: { [weak self] references in
        self?.didCollectedReferencesTrigger.accept(references)
    }, flowFinished: { [weak self] in
        self?.finished()
    })
    
    private lazy var didCollectedGeneralInfoTrigger = PublishRelay<GeneralInfo>()
    private lazy var didCollectedWorkExperienceTrigger = PublishRelay<[WorkExperience]>()
    private lazy var didCollectedEducationsTrigger = PublishRelay<[Education]>()
    private lazy var didCollectedProfessionalSkillsTrigger = PublishRelay<[ProfessionalSkill]>()
    private lazy var didCollectedLanguagesTrigger = PublishRelay<[Language]>()
    private lazy var didCollectedInterestsTrigger = PublishRelay<[Interest]>()
    private lazy var didCollectedCertificatesTrigger = PublishRelay<[Certificate]>()
    private lazy var didCollectedSocialMediaTrigger = PublishRelay<SocialMedia>()
    private lazy var didCollectedReferencesTrigger = PublishRelay<[Reference]>()
    
    private var chapter = Chapter.generalInfo
    
    private weak var vc: UIViewController?
    private let finished: (() -> Void)
    
    init(vc: UIViewController?, finished: @escaping (() -> Void)) {
        self.vc = vc
        self.finished = finished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chaptersViews.forEach { chapter, view in
            view.frame.size = container.bounds.size
        }
    }
}

// MARK: Public
extension CVMakerOnboardingView {
    var didCollectedGeneralInfo: Signal<GeneralInfo> {
        didCollectedGeneralInfoTrigger.asSignal()
    }
    
    var didCollectedWorkExperience: Signal<[WorkExperience]> {
        didCollectedWorkExperienceTrigger.asSignal()
    }
    
    var didCollectedEducations: Signal<[Education]> {
        didCollectedEducationsTrigger.asSignal()
    }
    
    var didCollectedProfessionalSkills: Signal<[ProfessionalSkill]> {
        didCollectedProfessionalSkillsTrigger.asSignal()
    }
    
    var didCollectedLanguages: Signal<[Language]> {
        didCollectedLanguagesTrigger.asSignal()
    }
    
    var didCollectedInterests: Signal<[Interest]> {
        didCollectedInterestsTrigger.asSignal()
    }
    
    var didCollectedCertificates: Signal<[Certificate]> {
        didCollectedCertificatesTrigger.asSignal()
    }
    
    var didCollectedSocialMedia: Signal<SocialMedia> {
        didCollectedSocialMediaTrigger.asSignal()
    }
    
    var didCollectedReferences: Signal<[Reference]> {
        didCollectedReferencesTrigger.asSignal()
    }
}

// MARK: Private
private extension CVMakerOnboardingView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        chaptersViews
            .forEach { [weak self] chapter, view in
                guard let self else { return }
                
                view.clipsToBounds = true
                
                if chapter == self.chapter {
                    container.addSubview(view)
                }
            }
        
        chaptersView.didSelect = { [weak self] chapter in
            self?.scroll(to: chapter)
        }
        
        chaptersView.setup(chapter: chapter)
    }
    
    func next(chapter: Chapter) {
        scroll(to: chapter)
        chaptersView.setup(chapter: chapter)
    }
    
    func scroll(to newChapter: Chapter) {
        let currentIndex = chapter.rawValue
        let scrollToIndex = newChapter.rawValue
        
        guard scrollToIndex != currentIndex else {
            return 
        }
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        guard
            let currentView = chaptersViews[chapter],
            let scrollToView = chaptersViews[newChapter]
        else {
            return
        }
        
        scrollToView.frame.size = container.bounds.size
        scrollToView.frame.origin = CGPoint(x: 393.scale * CGFloat(direction), y: 0)
        
        container.addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: {
            currentView.frame.origin = CGPoint(x: 393.scale * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            currentView.removeFromSuperview()
            
            self.chapter = newChapter
        })
    }
}

// MARK: Make constraints
private extension CVMakerOnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            chaptersView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chaptersView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chaptersView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.scale),
            chaptersView.heightAnchor.constraint(equalToConstant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: chaptersView.bottomAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerOnboardingView {
    func makeChaptersView() -> CVMakerChaptersView {
        let view = CVMakerChaptersView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
