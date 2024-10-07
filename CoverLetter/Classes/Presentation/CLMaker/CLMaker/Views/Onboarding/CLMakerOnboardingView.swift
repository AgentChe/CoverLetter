//
//  CLMakerOnboardingView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CLMakerOnboardingView: CLMakerFlowView {
    enum Chapter: Int {
        case personalInfo
        case companyInfo
        case hiringManager
        case vacancy
        case toneOnVoice
    }
    
    lazy var chaptersView = makeChaptersView()
    lazy var container = makeContainer()
    lazy var chaptersViews: [Chapter: UIView] = [
        .personalInfo: personalInfoView,
        .companyInfo: companyInfoView,
        .hiringManager: hiringManagerView,
        .vacancy: vacancyView,
        .toneOnVoice: toneOnVoiceView
    ]
    lazy var personalInfoView = CLMakerPersonalInfoView(bind: { [weak self] personalInfo in
        self?.didCollectedPersonalInfoTrigger.accept(personalInfo)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .companyInfo)
    })
    lazy var companyInfoView = CLMakerCompanyInfoView(bind: { [weak self] company in
        self?.didCollectedCompanyTrigger.accept(company)
    }, flowFinished: { [weak self] in
        self?.next(chapter: .hiringManager)
    })
    lazy var hiringManagerView = CLMakerHiringManagerView { [weak self] hiringManager in
        self?.didCollectedHiringManagerTrigger.accept(hiringManager)
        self?.next(chapter: .vacancy)
    }
    lazy var vacancyView = CLMakerVacancyView { [weak self] vacancy in
        self?.didCollectedVacancyTrigger.accept(vacancy)
        self?.next(chapter: .toneOnVoice)
    }
    lazy var toneOnVoiceView = CLMakerToneOfVoiceView(bind: { [weak self] toneOfVoice in
        self?.didCollectedToneOfVoiceTrigger.accept(toneOfVoice)
    }, flowFinished: { [weak self] in
        self?.finished()
    })
    
    private lazy var didCollectedPersonalInfoTrigger = PublishRelay<CLPersonalInfo>()
    private lazy var didCollectedCompanyTrigger = PublishRelay<CLCompany>()
    private lazy var didCollectedHiringManagerTrigger = PublishRelay<CLHiringManager>()
    private lazy var didCollectedVacancyTrigger = PublishRelay<CLVacancy>()
    private lazy var didCollectedToneOfVoiceTrigger = PublishRelay<CLToneOfVoice>()
    
    private var chapter = Chapter.personalInfo
    
    private let finished: () -> Void
    
    init(finished: @escaping () -> Void) {
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
extension CLMakerOnboardingView {
    var didCollectedPersonalInfo: Signal<CLPersonalInfo> {
        didCollectedPersonalInfoTrigger.asSignal()
    }
    
    var didCollectedCompany: Signal<CLCompany> {
        didCollectedCompanyTrigger.asSignal()
    }
    
    var didCollectedHiringManager: Signal<CLHiringManager> {
        didCollectedHiringManagerTrigger.asSignal()
    }
    
    var didCollectedVacancy: Signal<CLVacancy> {
        didCollectedVacancyTrigger.asSignal()
    }
    
    var didCollectedToneOfVoice: Signal<CLToneOfVoice> {
        didCollectedToneOfVoiceTrigger.asSignal()
    }
}

// MARK: Private
private extension CLMakerOnboardingView {
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
private extension CLMakerOnboardingView {
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
private extension CLMakerOnboardingView {
    func makeChaptersView() -> CLMakerChaptersView {
        let view = CLMakerChaptersView()
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
